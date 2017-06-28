############## VARIABLES ##############

export COMMON_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


############## GENERICS ##############


############## COLORING AND PRINTING ##############

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