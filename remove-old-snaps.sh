#!/bin/bash
# Remove old snaps.
#
# Close all Snaps before running.
#
# taken from: https://superuser.com/questions/1310825/how-to-remove-old-version-of-installed-snaps
set -eu

# shellcheck disable=SC2162
LANG=C snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done
