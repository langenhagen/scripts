#!/usr/bin/env bash
# Claude CLI UserPromptSubmit hook: keep shortmode in front of the model.
#
# A CLAUDE.md rule is read once at session start and fades as the conversation
# grows, so "shortmode" asked for forty messages ago stops being honoured. This
# hook restates it beside every prompt instead, which is the one place the model
# reliably reads.
#
# The existence of ~/.claude/shortmode is the switch, and the user's own words
# flip it: a prompt of "shortmode" turns it on, "shortmode off" turns it off.
# Whitespace is stripped and case ignored, so "ShortMode Off" matches too. The
# flip happens before the check, so the first reply after "shortmode" is already
# terse.
#
# Reads the hook's JSON payload on stdin (its `prompt` field holds the submitted
# text). Plain stdout on exit 0 is added to the model's context for this event.
#
# author: andreasl

set -euo pipefail

state_file="${HOME}/.claude/shortmode"

prompt="$(jq -r '.prompt // empty' | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"

case "${prompt}" in
shortmode) : >"${state_file}" ;;
shortmodeoff) rm -f "${state_file}" ;;
esac

[ -f "${state_file}" ] || exit 0

printf '%s\n' \
    'Shortmode is on. Answer in a word, a yes/no, or a fragment of at most about five words, unless asked for more. No explanations, caveats, TL;DR, or follow-up offers. Still do the work behind the answer; only the reply is terse.'
