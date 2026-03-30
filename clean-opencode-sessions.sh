#!/usr/bin/env bash
#
# Delete all Opencode memory sessions.
#
# Because Opencode is a vibe-coded piece of shite.

pkill -f opencode || true
rm -f "${HOME}/.local/share/opencode/"{opencode.db,opencode.db-shm,opencode.db-wal}
rm -rf "${HOME}/.local/share/opencode/storage/message/"*
rm -rf "${HOME}/.local/share/opencode/storage/part/"*
rm -rf "${HOME}/.local/share/opencode/storage/session/"*
rm -rf "${HOME}/.local/share/opencode/storage/session_diff/"*
rm -rf "${HOME}/.local/share/opencode/storage/todo/"*
rm -rf "${HOME}/.local/share/opencode/storage/project/"*
rm -rf "${HOME}/.local/share/opencode/snapshot/"*
rm -rf "${HOME}/.local/share/opencode/log/"*
rm -rf "${HOME}/.local/share/opencode/tool-output/"*
