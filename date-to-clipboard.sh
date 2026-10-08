#!/usr/bin/env bash
#
# Print today's date and copy it to the clipboard.
#
# Usage:
#
#   date-to-clipboard.sh            # print and copy "YYYY-MM-DD"
#   date-to-clipboard.sh --weekday  # print and copy "<WEEKDAY>, <DAY> <MONTH> <YEAR>"
#   date-to-clipboard.sh --paste    # additionally write the date into the focused window
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
  -p, --paste    Also insert the date into the focused window by typing it
                 (macOS: osascript, needs Accessibility permission;
                 Linux: xdotool on X11, wtype on Wayland)
  -h, --help     Show this help message and exit
HELP
}

# Type "$1" into the focused window. Typing is used instead of sending a
# paste shortcut because terminals and GUI apps disagree on that shortcut.
type_text() {
    if command -v osascript >/dev/null; then
        osascript \
            -e 'on run argv' \
            -e 'tell application "System Events" to keystroke (item 1 of argv)' \
            -e 'end run' "$1"
    elif [ -n "$WAYLAND_DISPLAY" ]; then
        wtype -- "$1"
    else
        xdotool type --clearmodifiers -- "$1"
    fi
}

date_format='%Y-%m-%d'
paste=false

while [ "$#" -gt 0 ]; do
    case "$1" in
    -h | --help)
        print_help
        exit 0
        ;;
    -w | --weekday)
        date_format='%A, %d %B %Y'
        ;;
    -p | --paste)
        paste=true
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

if [ "$paste" = true ]; then
    if [ -t 0 ]; then
        # When the focused window is this very terminal, the tty would echo
        # the typed characters while the script still runs, which leaves a
        # stray partial echo (e.g. "2") before the shell prompt. Silence the
        # echo; the shell still receives the buffered keystrokes afterwards.
        tty_state="$(stty -g)"
        trap 'stty "$tty_state"' EXIT
        stty -echo
    fi
    type_text "$out"
    # let the synthetic key events reach the terminal before echo is restored
    sleep 0.2
fi
