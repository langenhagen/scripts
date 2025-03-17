#!/usr/bin/env python3
"""Scan a folder for python files and create a `Mermaid` class diagram.

Limitations:
- imports inside functions or and redefinitions of thingos may cause undefined behavior
- wildcard imports will not be resolved
- forward imports and stuffs via `__init__.py` might as well break
- does not account for dirty tricks with your PYTHONPATH

Use like:

    python scan_class_hierarchy.py . | tee ~/Desktop/diagram.md

Then, you can e.g. do:

    nvm use lts;
    mmdc --width 10000 --height 10000 -i ~/Desktop/diagram.md -o ~/Desktop/output.png;
    feh ~/Desktop/output-1.png;

TODO:
- nest modules
"""

import ast
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path
from string import ascii_uppercase
from typing import Generator

write = sys.stdout.write


def n_to_alpha(n: int) -> str:
    """For the given number, return an alpha-string.

    The string should look like so that:
    1 maps to "A"
    2 maps to "B"
    ...
    27 maps to "AA"
    28 maps to "AB"
    and so on.
    """
    result = []
    while n > 0:
        n, remainder = divmod(n - 1, 26)
        result.append(ascii_uppercase[remainder])
    return "".join(result[::-1])


def walk(
    path: Path,
    file_regex: str | None = None,
    ignore_regex: str | None = None,
) -> Generator[Path, None, None]:
    """Recursively walk a directory in a depth-first manner.

    If given, files should match the given `file_regex`.

    Also, if a file or folder matches the given regex, ignore this item and do
    not descend further into this direction.
    """
    for p in path.iterdir():
        resolved = p.resolve()
        if ignore_regex and re.match(ignore_regex, resolved.name):
            continue
        if p.is_dir():
            yield from walk(p, file_regex, ignore_regex)
        elif file_regex is None or re.match(file_regex, resolved.name):
            yield p


@dataclass
class Import:
    """Represent an import in a Python module."""

    qualified_name: str
    alias: str


@dataclass
class Class:
    """Represents a class and its direct superclasses in the right order."""

    name: str
    superclasses: list[str] = field(default_factory=list)

    @property
    def last_name_part(self) -> str:
        """Return only the last part of the (qualified) name.
        E.g., for `my.cool.Class`, return `Class`.
        """
        return self.name.split(".")[-1]


@dataclass
class Module:
    """Represents a Python module."""

    file: Path
    imports: list[Import] = field(default_factory=list)
    classes: list[Class] = field(default_factory=list)

    @property
    def module_path(self) -> str:
        """Get the modulized path name.

        E.g., if the `file` field is `my/module.py`, the result is `my.module`.
        """
        return str(self.file).replace("/", ".").removesuffix(".py")


def parse_file(file: Path) -> Module:
    """From the given Python file, extract Python imports, classes and their
    superclasses.
    """
    with file.open() as f:
        tree = ast.parse(f.read())

    result = Module(file=file)

    for node in ast.walk(tree):
        if isinstance(node, ast.Import):
            # import ... [as ...]
            for import_name in node.names:
                alias = import_name.asname or import_name.name
                imp = Import(qualified_name=import_name.name, alias=alias)
                result.imports.append(imp)
        elif isinstance(node, ast.ImportFrom):
            # from ... import ... [as ...]
            module_path = node.module
            for import_name in node.names:
                if import_name.name == "*":
                    continue
                qual_name = f"{module_path}.{import_name.name}"
                alias = import_name.asname or import_name.name
                imp = Import(qualified_name=qual_name, alias=alias)
                result.imports.append(imp)
        elif isinstance(node, ast.ClassDef):
            # class
            supers = []
            for base in node.bases:
                if isinstance(base, ast.Attribute):
                    # mymodule.MyClass, my.module.MyClass and so on
                    parent = base
                    name_parts: list[str] = []
                    while not isinstance(parent, ast.Name):
                        name_parts.append(parent.attr)
                        parent = parent.value
                    name_parts.append(parent.id)
                    name_parts.reverse()
                    name = ".".join(name_parts)
                    supers.append(name)
                elif isinstance(base, ast.Name):
                    # MyClass, IntEnum and the likes
                    supers.append(base.id)
                elif isinstance(base, ast.Starred):
                    # arcane stuff like class DummyWA(*supers):
                    pass
                elif isinstance(base, ast.Subscript):
                    # generics stuff like: Generic[ElementType], unsupported atm
                    pass
                else:
                    msg = f"That should never happen {type(base)}: {file}: {node.name}"
                    raise TypeError(msg)

            result.classes.append(Class(name=node.name, superclasses=supers))

    return result


def convert_superclass_names_to_qualified_names(module: Module) -> None:
    """Convert superclass names to.qualified.names."""
    module_path = module.module_path

    for c in module.classes:
        qualified_supers: list[str] = []
        for s in c.superclasses:
            qualified_super: str | None = None
            for i in module.imports:
                if i.alias == s:
                    # superclass alias found as import
                    qualified_super = i.qualified_name
                    break
                if False:
                    # superclass alias found as import
                    qualified_super = i.qualified_name
                    break
            if qualified_super is None:
                for c2 in module.classes:
                    if c2.name == s:
                        # superclass alias found in same module
                        qualified_super = f"{module_path}.{s}"
                        break
            if qualified_super is None:
                # keep initial superclass name if not found
                qualified_super = s

            qualified_supers.append(qualified_super)

        c.superclasses = qualified_supers


def convert_class_names_to_qualified_names(module: Module) -> None:
    """Convert class names to.qualified.names."""
    module_path = module.module_path
    for c in module.classes:
        c.name = f"{module_path}.{c.name}"


def write_output(modules: list[Module]) -> None:
    """Write the module info to stdout as a Mermaid diagram."""
    write("```mermaid\n")
    write("graph RL;\n")
    for i, m in enumerate(modules, start=1):
        if len(m.classes) == 0:
            continue

        subgraph_id = n_to_alpha(i)
        write(f'subgraph {subgraph_id}["{m.module_path}"]\ndirection TB;\n')
        for c in m.classes:
            write(f'  {c.name}["{c.last_name_part}"]\n')

        write("end\n")

        for c in m.classes:
            for j, s in enumerate(c.superclasses, start=2):
                if s == "object":
                    continue
                write(f"  {c.name} {'-' * j}> {s}\n")

    write("```\n")


def main(directory: Path) -> int:
    """Scan the given directory for python classes and their inheritance-relation."""
    generator = walk(directory, file_regex=r".*\.py$", ignore_regex=r"\..+|__pycache__")
    modules: list[Module] = [parse_file(file) for file in generator]

    for m in modules:
        convert_superclass_names_to_qualified_names(m)
        convert_class_names_to_qualified_names(m)

    write_output(modules)

    return 0


if __name__ == "__main__":
    directory = Path("." if len(sys.argv) == 1 else sys.argv[1])
    sys.exit(main(directory))
