#!/usr/bin/env bash
#
# Print everything Claude wrote since the user's last message, read straight
# from a Claude Code transcript.
#
# Usage:
#
#   claude-last-reply.sh                   # use the newest transcript
#   claude-last-reply.sh TRANSCRIPT.jsonl  # use the given transcript
#
# Karabiner's F7 key pipes the output into `kokoro`. With several sessions
# open, the newest transcript is the session that wrote last.
#
# A real user message is a `type: "user"` entry that is neither a
# tool-result (those carry a `toolUseResult` key a typed message never has)
# nor a harness-synthesized entry such as a slash-command echo or a
# <task-notification> (those wrap their content in a leading `<tag>`).
#
# author: andreasl

set -euo pipefail

newest_transcript() {
    local newest=""
    local transcript
    for transcript in "${HOME}"/.claude/projects/*/*.jsonl; do
        if [ -z "${newest}" ] || [ "${transcript}" -nt "${newest}" ]; then
            newest="${transcript}"
        fi
    done
    printf '%s\n' "${newest}"
}

transcript_path="${1:-$(newest_transcript)}"

jq -rs '
    def user_text:
        .message.content // ""
        | if type == "string" then .
          else map(select(.type == "text") | .text) | join("")
          end;

    to_entries as $entries
    | ($entries
       | map(select(
           .value.type == "user"
           and (.value | has("toolUseResult") | not)
           and (.value | user_text | ltrimstr(" ") | startswith("<") | not)
         ))
       | last.key // -1
      ) as $last_user_idx
    | [ $entries[]
        | select(.key > $last_user_idx)
        | .value
        | select(.type == "assistant")
        | .message.content[]?
        | select(.type == "text")
        | .text
      ]
    | join("\n\n")
' "${transcript_path}"
