#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "beautifulsoup4",
#     "ebooklib",
# ]
# ///
"""Split an EPUB into one plain-text file per chapter.

Usage:
    uv run split-epub.py BOOK.epub [--out TEXT_DIR] [--no-title]

Reads the EPUB spine in reading order, strips HTML, and writes
chapter_NN.txt files into the output directory. Documents with almost
no text (covers, nav pages) are skipped and reported.
"""

import argparse
import re
from pathlib import Path

from bs4 import BeautifulSoup
from ebooklib import ITEM_DOCUMENT, epub

MIN_CHAPTER_CHARS = 50


def parse_args() -> argparse.Namespace:
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(
        description="Split an EPUB into one plain-text file per chapter.",
    )
    parser.add_argument("epub", type=Path, help="Path to the source EPUB file")
    parser.add_argument(
        "--out",
        type=Path,
        default=Path("text"),
        help="Output directory for chapter text files (default: text)",
    )
    parser.add_argument(
        "--no-title",
        action="store_true",
        help="Do not write the chapter title as the first line",
    )
    return parser.parse_args()


def clean_text(raw: str) -> str:
    """Strip lines, collapse inner whitespace, and drop repeated blank lines."""
    lines = (re.sub(r"[ \t]+", " ", line.strip()) for line in raw.splitlines())
    out: list[str] = []
    blank = True
    for line in lines:
        if line:
            out.append(line)
            blank = False
        elif not blank:
            out.append("")
            blank = True
    while out and not out[-1]:
        out.pop()
    return "\n".join(out)


def extract_title(soup: BeautifulSoup) -> str | None:
    """Return the chapter title from the first heading or the document title."""
    for level in ("h1", "h2", "h3"):
        for tag in soup.find_all(level):
            text = clean_text(tag.get_text())
            if text:
                return text.splitlines()[0]
    if soup.title is not None:
        text = clean_text(soup.title.get_text())
        if text:
            return text.splitlines()[0]
    return None


def spine_documents(book: epub.EpubBook) -> list[epub.EpubItem]:
    """Return spine items that are XHTML documents, in reading order."""
    docs = []
    for entry in book.spine:
        item_id = entry[0] if isinstance(entry, tuple) else entry
        item = book.get_item_with_id(item_id)
        if item is None or item.get_type() != ITEM_DOCUMENT:
            continue
        docs.append(item)
    return docs


def write_chapters(
    parsed: list[tuple[str, str | None, str]],
    out_dir: Path,
    include_title: bool,
) -> None:
    """Write numbered chapter text files and print one line per file."""
    width = max(2, len(str(len(parsed))))
    for index, (_, title, text) in enumerate(parsed, start=1):
        path = out_dir / f"chapter_{index:0{width}d}.txt"
        prefix = title if title and include_title else None
        body = f"{prefix}\n\n{text}\n" if prefix else f"{text}\n"
        path.write_text(body, encoding="utf-8")
        label = title or "untitled"
        print(f"{path}  <- {label} ({len(text)} chars)")


def main() -> None:
    """Entry point."""
    args = parse_args()
    book = epub.read_epub(args.epub)

    parsed: list[tuple[str, str | None, str]] = []
    skipped: list[str] = []
    for item in spine_documents(book):
        soup = BeautifulSoup(item.get_content(), "html.parser")
        title = extract_title(soup)
        for tag in soup(["script", "style", "head"]):
            tag.decompose()
        text = clean_text(soup.get_text("\n"))
        if len(text) < MIN_CHAPTER_CHARS:
            skipped.append(item.get_name())
            continue
        if title and not args.no_title:
            lines = text.splitlines()
            if lines and lines[0] == title:
                text = clean_text("\n".join(lines[1:]))
        parsed.append((item.get_name(), title, text))

    if not parsed:
        message = "No chapter content found in the EPUB."
        raise SystemExit(message)

    args.out.mkdir(parents=True, exist_ok=True)
    write_chapters(parsed, args.out, not args.no_title)

    if skipped:
        print(f"\nSkipped {len(skipped)} near-empty document(s):")
        for name in skipped:
            print(f"  {name}")
    print(f"\n{len(parsed)} chapter file(s) written to {args.out}/")


if __name__ == "__main__":
    main()
