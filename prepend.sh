# TODO make prepend script out of it

set -x

cd /home/andreasl/c1/stuff/scribbles_trans
files_str="$(ls *.md)"
mapfile -t files <<< "$files_str"

for file in "${files[@]}"; do

    print "################################## $file ##################################\n"

    file_content="$(cat $file)"

    file_name="$(basename "$file")"
    file_date="${file_name:0:10}"
    file_title="${file_name:11:999}"
    printf -- '---\n' > "$file"
    printf -- "layout: post\n" >> "$file"
    printf -- "title: ${file_title}\n" >> "$file"
    printf -- "date: ${file_date}\n" >> "$file"
    printf -- "tags: [investigation]\n" >> "$file"
    printf -- "---\n" >> "$file"
    printf -- "$file_content" >> "$file"

done
