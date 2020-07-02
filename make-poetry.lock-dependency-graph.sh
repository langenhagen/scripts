#!/bin/bash
# Create a plantuml dependency graph from the given poetry.lock file.
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

lockfile_path="$1"
[ -n "$lockfile_path" ] || die "$(show_usage)" 1
[ -e "$lockfile_path" ] || die "Error: Lockfile \"${lockfile_path}\" does not exist." 1

output_file="${2:-dependencies.plantuml}"

lockfile="$(cat "$lockfile_path")"
printf '@startuml\n\n' > "$output_file"
grep '^name = .*$' <<< "$lockfile" | sed 's/.*"\(.*\)"/rectangle \1/g' >> "$output_file"

package_dependencies_str="$(grep -En '^(name =.*|\[package.dependencies\])$' <<< "$lockfile")"
mapfile -t package_dependencies <<< "$package_dependencies_str"
mapfile -t lockfile_array <<< "$lockfile"
for i in $(seq ${#package_dependencies[@]}); do
    [[ "${package_dependencies[${i}]}" == *'[package.dependencies]' ]] || continue
    printf '\n' >> "$output_file"
    dependee="$(sed 's/.*"\(.*\)"/\1/g' <<< "${package_dependencies[$((i - 1 ))]}")"
    j="$(cut -d: -f1 <<< "${package_dependencies[${i}]}" )"
    while [ -n "${lockfile_array[${j}]}" ]; do
        dependency="$(sed 's/\(\) .*"/\1/g' <<< "${lockfile_array[${j}]}")"
        printf '%s -down-> %s\n' "$dependee" "$dependency" >> "$output_file"
        (( j += 1 ))
    done
done

printf '\n@enduml\n' >> "$output_file"

plantuml "$output_file"
xdg-open "${output_file%.*}.png"
