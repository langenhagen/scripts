#!/usr/bin/env bash
# For macOS.
# Claude CLI stop hook: write everything Claude wrote since the user's last
# message to ~/.claude/last-message.txt, so Karabiner's F7 -> `say -f` reads
# the full reply instead of a stale or truncated fragment.
#
# Reads the hook's JSON payload on stdin (has `.transcript_path`), finds the
# last genuine typed user message, and concatenates every assistant text
# block written after that point.
#
# A real user message is a `type: "user"` entry that is neither a
# tool-result (those carry a `toolUseResult` key a typed message never has)
# nor a harness-synthesized entry such as a slash-command echo or a
# <task-notification> (those wrap their content in a leading `<tag>`).
#
# The hook fires once per turn, ~15-20ms after the reply is produced -
# before the transcript's final assistant line is reliably flushed to disk.
# Reading immediately therefore usually yields the turn's text minus its
# last block, or nothing at all. So poll until the extracted text is
# non-empty and unchanged across two consecutive reads, which also covers a
# turn whose text arrives as several separately-flushed blocks. If nothing
# ever shows up, skip the write rather than clobbering the previous real
# message with an empty file.
#
# author: andreasl

set -euo pipefail

out_file="${HOME}/.claude/last-message.txt"
settle_interval_seconds=0.1
settle_max_attempts=20

input="$(cat)"
transcript_path="$(printf '%s' "${input}" | jq -r '.transcript_path')"

extract_message() {
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
}

message=""
previous_message=""
attempt=0
while [ "${attempt}" -lt "${settle_max_attempts}" ]; do
    # The transcript is being appended to as this runs, so a read can land
    # on a half-written line and make jq fail; retry instead of aborting.
    message="$(extract_message || true)"
    if [ -n "${message}" ] && [ "${message}" = "${previous_message}" ]; then
        break
    fi
    previous_message="${message}"
    attempt=$((attempt + 1))
    sleep "${settle_interval_seconds}"
done

if [ -z "${message}" ]; then
    exit 0
fi

tmp_file="$(mktemp "${out_file}.XXXXXX")"
trap 'rm -f "${tmp_file}"' EXIT

printf '%s\n' "${message}" >"${tmp_file}"
mv "${tmp_file}" "${out_file}"
trap - EXIT
