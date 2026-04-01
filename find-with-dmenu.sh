#!/usr/bin/env bash
# Call dmenu and ask for a search query to call find under the ${HOME} directory,
# then call dmenu with the list of results.
# Attempt to open the result of the latter query with xdg-open or a comparable tool.
#
# At the moment, this script uses the ~/.config/edm/edmrc file but possibly, it does not need any
# rc file or deserves its own.
#
# Usage:
#
#   find-with-dmenu.sh
#
# author: andreasl

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/edm"
mkdir -p "$config_dir"

define_standard_settings() {
    root_path="$HOME"
    if [ "$(uname)" == "Darwin" ]; then
        open_command='open'
    else
        open_command='xdg-open'
    fi
}
define_standard_settings
source "${config_dir}/edmrc" 2>/dev/null

search_history_file="${HOME}/.fwdm_history"
historic_searches="$(tac "$search_history_file")"
if ! search_query="$(printf -- "$historic_searches" | dmenu -i -l 3 -p "search for?:")"; then
    exit 1
fi

sed -i "/${search_query}/d" "$search_history_file"
echo "$search_query" >>"$search_history_file"

search_results="$(find "$root_path" -iname "*${search_query}*" 2>/dev/null)"
if ! selected_result="$(printf '%s\n' "${search_results[@]}" | dmenu -i -p "select:" -l 30)"; then
    exit 2
fi

eval "${open_command} \"${selected_result}\""
