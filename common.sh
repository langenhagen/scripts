############## VARIABLES ##############

export COMMON_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# --------------------------------------------------------------------------------------------------
# Generics

# Returns the directory of the script this line is in. Does not behave with symlinks
DIR_OF_THIS_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# --------------------------------------------------------------------------------------------------
# Coloring and printing

CYAN='\033[1;36m'
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function echo-error {
    printf "${RED}${@}${NC}\n"
}

function echo-head {
    printf "${CYAN}${@}${NC}\n"
}

function echo-ok {
    printf "${GREEN}${@}${NC}\n"
}

function echo-warn {
    printf "${YELLOW}${@}${NC}\n"
}


function check_if_this_computer_is_a_mac {
    if echo $HOME | grep -v -q "/Users/" ; then
        echo "we're not on mac"
    else
        echo "we're on mac"
    fi
}

# --------------------------------------------------------------------------------------------------

function gitup {
    # if you are in a git repo, move up to its top level

    git_dir="$(git rev-parse --show-toplevel 2> /dev/null)"
    if [ -z $git_dir ] ; then
        cd ..
    else
        cd $git_dir
    fi
}
