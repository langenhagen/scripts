#!/usr/bin/env bash
# Claude CLI stop hook: read the last reply aloud with Kokoro while jarvis mode
# is on.
#
# Does nothing unless ~/.claude/jarvis exists (see claude-jarvis-hook.sh).
# Speaks ~/.claude/last-message.txt, which write-last-claude-message.sh
# writes.
#
# Hooks of one event run in parallel, so chain the two in the hook
# command (`write-last-claude-message.sh && claude-jarvis-speak.sh`) to avoid
# reading the previous reply. `kokoro` blocks until playback ends.
#
# author: andreasl

set -euo pipefail

[ -f "${HOME}/.claude/jarvis" ] || exit 0

kokoro --speed 1.2 "${HOME}/.claude/last-message.txt"
