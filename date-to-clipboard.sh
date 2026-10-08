#!/usr/bin/env bash
#
# Print today's date and copy it to the clipboard.
#
# Usage:
#
#   date-to-clipboard.sh            # print and copy "YYYY-MM-DD"
#   date-to-clipboard.sh --weekday  # print and copy "<WEEKDAY>, <DAY> <MONTH> <YEAR>"
#   date-to-clipboard.sh --help     # show help
#
# author: andreasl

print_help() {
    cat <<'HELP'
Usage: date-to-clipboard.sh [OPTIONS]

Print today's date and copy it to the clipboard.
Default format is "YYYY-MM-DD".

Options:
  -w, --weekday  Use "<WEEKDAY>, <DAY> <MONTH> <YEAR>" format
  -h, --help     Show this help message and exit
HELP
}

date_format='%Y-%m-%d'

while [ "$#" -gt 0 ]; do
    case "$1" in
    -h | --help)
        print_help
        exit 0
        ;;
    -w | --weekday)
        date_format='%A, %d %B %Y'
        ;;
    *)
        printf 'Unknown option: %s\n\n' "$1" >&2
        print_help >&2
        exit 1
        ;;
    esac
    shift
done

out="$(date "+$date_format")"

command -v pbcopy >/dev/null && clip_cmd=(pbcopy) || clip_cmd=(xclip -selection clipboard)

printf '%s\n' "$out"
printf '%s' "$out" | "${clip_cmd[@]}"
