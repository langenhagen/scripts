#!/usr/bin/env bash
# Claude CLI UserPromptSubmit hook: keep jarvis mode in front of the model.
#
# Jarvis mode is shortmode with spoken replies. The existence of
# ~/.claude/jarvis is the switch, and the user's own words flip it: a prompt of
# "jarvis" turns it on, "jarvis off" turns it off. Whitespace and punctuation
# are stripped and case ignored, so a dictated "Jarvis." matches too. The flip
# happens before the check, so the first reply after "jarvis" is already terse.
#
# Jarvis and shortmode give conflicting length rules, so only one stays on:
# "jarvis" also removes ~/.claude/shortmode, and "shortmode" removes
# ~/.claude/jarvis. claude-shortmode-hook.sh sets its own marker file.
#
# While the file exists this hook restates the terse rule beside every prompt
# (see claude-shortmode-hook.sh for why), and claude-jarvis-speak.sh reads each
# reply aloud with Kokoro.
#
# Reads the hook's JSON payload on stdin (its `prompt` field holds the submitted
# text). Plain stdout on exit 0 is added to the model's context for this event.
#
# author: andreasl

set -euo pipefail

state_file="${HOME}/.claude/jarvis"
shortmode_file="${HOME}/.claude/shortmode"

enable_jarvis() {
    rm -f "${shortmode_file}"
    : >"${state_file}"
}
disable_jarvis() { rm -f "${state_file}"; }

prompt="$(jq -r '.prompt // empty' | tr -d '[:space:][:punct:]' | tr '[:upper:]' '[:lower:]')"

case "${prompt}" in
jarvis) enable_jarvis ;;
jarvisoff | shortmode) disable_jarvis ;;
esac

[ -f "${state_file}" ] || exit 0

printf '%s\n' \
    'Jarvis mode is on; your reply is read aloud. Answer in a word, a yes/no, or a fragment of at most about 7 words, unless asked for more or really necessaryaa - even then, answer in kokoro-friendly prose always. No explanations, caveats, TL;DR, or follow-up offers. Still do the work behind the answer; only the reply is terse.'
