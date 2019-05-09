############## VARIABLES ##############

COMMON_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# --------------------------------------------------------------------------------------------------
# Generics

# Returns the directory of the script this line is in. Does not behave with symlinks
DIR_OF_THIS_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# --------------------------------------------------------------------------------------------------
# Coloring and printing

CYAN='\e[1;36m'
RED='\e[0;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
NC='\e[0m' # No Color

function echo-error {
    printf "${RED}${*}${NC}\n"
}

function echo-head {
    printf "${CYAN}${*}${NC}\n"
}

function echo-ok {
    printf "${GREEN}${*}${NC}\n"
}

function echo-warn {
    printf "${YELLOW}${*}${NC}\n"
}

function check_if_this_computer_is_a_mac {
    if echo "$HOME" | grep -v -q "/Users/" ; then
        echo 'client is not a mac'
    else
        echo 'client is a mac'
    fi
}

function gitup {
    # if you are in a git repo, move up to its top level

    git_dir="$(git rev-parse --show-toplevel 2> /dev/null)"
    cd "$git_dir" || cd .. || exit 1
}

function increment_count {
    # Given a file path and a grep pattern,
    # finds corresponding line in the given file and applies an +1 increment
    # to the last column in the line.
    # The line's last column must consist of a number.
    # There should exactly be one matching line.
    # The file should exist.
    # The function does no error checking!
    #
    # Parameters:
    #   $1:  the grep-pattern for which to look for.
    #   $2:  the file name in which to find the line whose last column is to be incremented.
    #
    # Example:
    #   contents of myfile.txt before execution:
    #       Hello world,
    #       The current count is: 0
    #
    #   # invoke function
    #   increment_count "current count is: " "path/to/my/file.txt"
    #
    #   contents of myfile.txt after execution:
    #       Hello world,
    #       The current count is: 1
    # .

    local line
    line=$(grep "$1" "$2")
    local current_count
    current_count=$(echo "$line" | awk '{print $NF}')
    local new_count
    (( new_count = current_count+1 ))
    local new_line
    new_line=$(echo "$line" | awk -v nc="$new_count" '{$NF = nc; print}')
    sed -i "s/${line}/${new_line}/" "$2"
}

function is_folder_empty {
    if [ -z "$(ls -A "$1")" ]; then
        echo 'given folder is empty'
    else
        echo 'given folder is NOT empty'
    fi
}
