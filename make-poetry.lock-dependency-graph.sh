#!/bin/bash
# Create a graphviz dot dependency graph from the given poetry.lock file.
#
# TODO: consider implementing variable only_main=true
#
# author: andreasl

show_usage() {
    script_name="${0##*/}"

    msg="Usage:\n"
    msg+="  ${script_name} <lockfile> [<output-file>]\n"
    msg+="\n"
    msg+="Examples:\n"
    msg+="  ${script_name} 'poetry.lock'            # Create a graph from poetry.lock and store it "
    msg+="to dependencies.plantuml\n"
    msg+="  ${script_name} 'poetry.lock'  out.txt   # Create a graph from poetry.lock and store it "
    msg+="to out.txt\n"
    printf "$msg"
}

die() {
    printf '%s\n' "$1"
    exit "$2"
}

[[ "$1" =~ ^(-h|--help)$ ]] && die "$(show_usage)" 0

lockfile_path="$1"
[ -n "$lockfile_path" ] || die "$(show_usage)" 1
[ -e "$lockfile_path" ] || die "Error: Lockfile \"${lockfile_path}\" does not exist." 1
output_file="${2:-dependencies.plantuml}"

printf 'digraph D {\n\n' >"$output_file"

lockfile="$(cat "$lockfile_path")"
grep '^name = .*$' <<<"$lockfile" | sed 's/.*"\(.*\)"/"\1" [shape=box]/g' >>"$output_file"

package_dependencies_str="$(grep -En '^(name =.*|\[package.dependencies\])$' <<<"$lockfile")"
mapfile -t package_dependencies <<<"$package_dependencies_str"
mapfile -t lockfile_array <<<"$lockfile"
for i in $(seq ${#package_dependencies[@]}); do
    [[ "${package_dependencies[${i}]}" == *'[package.dependencies]' ]] || continue
    printf '\n' >>"$output_file"
    dependee="$(sed 's/.*"\(.*\)"/\1/g' <<<"${package_dependencies[$((i - 1))]}")"
    j="${package_dependencies[${i}]%%:*}"
    while [ -n "${lockfile_array[${j}]}" ]; do
        dependency="$(sed 's/\(\) .*["{}]/\1/g' <<<"${lockfile_array[${j}]}")"
        printf '"%s" -> "%s"\n' "$dependee" "$dependency" >>"$output_file"
        ((j += 1))
    done
done

printf '\n}\n' >>"$output_file"

dot -Tpng -o "${output_file%.*}.png" "$output_file"
command -v xdg-open 2>/dev/null && xdg-open "${output_file%.*}.png"
