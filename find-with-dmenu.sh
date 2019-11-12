#!/bin/bash
# Calls dmenu and asks for a search query to call find under the ${HOME} directory,
# then calls dmenu with the list of results.
# The result of the latter query is attempted to be opened with xdg-open or a comparable tool.
#
# At the moment, this script uses the ~/.edmrc file but possibly, it does not need any rc file or
# deserves its own.
#
# author: andreasl

function define_standard_settings {

    root_path="$HOME"

    if [ "$(uname)" == "Darwin" ]; then
        open_command='open'
    else
        open_command='xdg-open'
    fi
}

define_standard_settings
source "${HOME}/.edmrc" 2>/dev/null

search_history_file="${HOME}/.fwdm_history"
historic_searches="$(tac "$search_history_file")"

search_query="$(printf -- "$historic_searches" | dmenu -i -l 3 -p "search for?:" )"
if [ $? != 0 ]; then
    exit 1
fi

sed -i "/${search_query}/d" "$search_history_file"
echo "$search_query" >> "$search_history_file"

search_results="$(find "$root_path" -iname "*${search_query}*" 2>/dev/null)"

selected_result="$(printf '%s\n' "${search_results[@]}" | dmenu -i -p "select:" -l 30)"
if [ $? != 0 ]; then
    exit 2
fi

eval "${open_command} \"${selected_result}\""
