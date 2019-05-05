#!/bin/bash
#
# Iterates over commit range,, checks out every revision in reverse order and performs actions on
# each revision. Sums up the exit codes of each action and returns this sum at the end.
#
# author: andreasl

oldrev="$1"
newrev="$2"

all_revs="$(git rev-list $oldrev..$newrev)"

# For experimental reasons
echo
echo "All revs:"
echo "$all_revs"
echo

prior_rev="$(git rev-parse HEAD)"
script_dir="$(dirname "${BASH_SOURCE[0]}")"
exit_code=0
for rev in $all_revs; do
    git checkout "$rev" 1>/dev/null 2>&1

    # For experimental reasons
    echo
    echo "current rev:"
    echo "$rev"
    echo

    bash "${script_dir}/lint-python-files-in-git-HEAD.sh"
    exit_code=$((exit_code + $?))

    # TODO do more actions here ....

    # For experimental reasons
    echo
    echo "exit_code:"
    echo "$exit_code"
    echo
done

git checkout "$prior_rev" 1>/dev/null 2>&1

exit "$exit_code"