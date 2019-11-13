#!/bin/bash
#
# Runs autopep against a list of files
#
# author: andreasl


staged_python_files=$(git diff --name-only --cached | grep -i "\.py$")  # fetch staged *.py files



# 2. for each staged python file go through its patches and autopep8 check them
# 3. proceed y/n?
# 4. for each staged python file go through its patches and autopep8 patch them





${HOME}/.config/pep8
${HOME}/.config/.pycodestyle  # autopep config, taken from https://pypi.org/project/autopep8/#features





autopep8 -j 8 --diff  # --diff: print diff for fixed source

# -i, --in-place
# -v --verbose
# --list-fixes
# --list-fixes          list codes for fixes; used by --ignore and --select
#  --ignore errors       do not fix these errors/warnings (default:
#                        E226,E24,W50,W690)
#  --select errors       fix only these errors/warnings (e.g. E4,W)
#  --max-line-length n   set maximum allowed line length (default: 79)
#  --line-range line line, --range line line
#                        only fix errors found within this inclusive range of
#                        line numbers (e.g. 1 99); line numbers are indexed at
#                        1
# --exit-code           change to behavior of exit code. default behavior of
#                       return value, 0 is no differences, 1 is error exit.
#                       return 2 when add this option. 2 is exists
#                       differences.  andreasl: Use on first pass to detect whether changes could be applied

# get the file diffs
# that Could be a good list of possible resources
git diff HEAD HEAD~1                                                # create a diff output of two commits
git diff master..mybranch                                           # creates a diff between the tips of the two branches
git diff --name-only                                            # get the staged, file paths, i.e. not the unstaged
git diff --name-only HEAD                                       # get the changed, uncommitted files' paths that differ from HEAD, i.e. staged and unstaged
git diff --name-only origin/master...HEAD                      # get the changed files between origin/master; order important
git diff master...mybranch                                          # creates a diff from their common ancestor to test
git ls-remote origin                                                # git show all remote branches
git pull origin feature/ev-routing                                  # git pull from remote branch
git diff-tree --no-commit-id --name-only -r HEAD~1                  # git list all the files that have been changed in the given commit


autopep8_config_file="${HOME}/.config/pep8"
cat > "$autopep8_config_file" << EOF
[pycodestyle]
max_line_length = 100
ignore = E501
# ...
EOF

num_issues_found_by_autopep8=0
for patch in ${diffs[@]}; do
    get patch_start_line
    get patch_end_line
    get patch_filename
    autopep8 -j 8 --in-place --exit-code --exit-code --line-range ${patch_start_line} ${patch_end_line} ${patch_filename}
    (( num_issues_found_by_autopep8 += ${?}/2 ))  # divide by 2 because autopep --exit-code returns 2 for 'issues found'
done

if error code

read -e -n1 -p 'Continue? [yY/nN]: ' key
if [ "$key" != 'y' ] && [ "$key" != 'Y' ]; then
    echo 'Bye!'
    exit 1
fi


for patch in ${diffs[@]}; do
    get patch_start_line
    get patch_end_line
    get patch_filename
    autopep8 -j 8 --diff --list-fixes --exit-code --line-range ${patch_start_line} ${patch_end_line} ${patch_filename}
done
