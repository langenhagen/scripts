#!/usr/bin/env bash
# Remove old snaps.
#
# Keeps the currently active revisions of snaps and removes older, disabled, versions left behind
# after updates.
#
# taken from: https://superuser.com/questions/1310825/how-to-remove-old-version-of-installed-snaps
#
# Close all Snaps before running.
#
# Usage:
#
#   remove-old-snaps.sh
#
set -eu

# shellcheck disable=SC2162
LANG=C snap list --all |
    awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done
