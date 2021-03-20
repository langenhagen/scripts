#!/bin/bash
# Clone all my github repos into a folder.
#
# I created the list on 2021-03-20 via:
#
#   gh repo list -L999 | grep -iv fork | cut -f1 > repos.txt
#
# see: https://github.com/cli/cli
#
# author: andreasl
set -e;

repo_dir="${HOME}/repos"
[ -e "$repo_dir" ] && { printf "Error: Directory ${repo_dir} exists already!"; exit 1; }

mkdir -p "$repo_dir"
cd "$repo_dir"

time {
    git clone git@github.com:langenhagen/awesome-lists
    git clone git@github.com:langenhagen/Bachelor-Thesis
    git clone git@github.com:langenhagen/barn-bar
    git clone git@github.com:langenhagen/barn-bits
    git clone git@github.com:langenhagen/barn-bookmark-manager
    git clone git@github.com:langenhagen/barn-keylogger
    git clone git@github.com:langenhagen/barn-scrape
    git clone git@github.com:langenhagen/barn-sidebar
    git clone git@github.com:langenhagen/barn-sleeptimer
    git clone git@github.com:langenhagen/barn-test
    git clone git@github.com:langenhagen/bee-scripts
    git clone git@github.com:langenhagen/blog
    git clone git@github.com:langenhagen/bslideshow
    git clone git@github.com:langenhagen/bWake
    git clone git@github.com:langenhagen/c1-dev-gerrit-hooks
    git clone git@github.com:langenhagen/celeraone-howtos
    git clone git@github.com:langenhagen/celeraone-notes
    git clone git@github.com:langenhagen/celeraone-scripts
    git clone git@github.com:langenhagen/check
    git clone git@github.com:langenhagen/CLNrpsR3M3
    git clone git@github.com:langenhagen/coding-challenges
    git clone git@github.com:langenhagen/db4o-wrappers
    git clone git@github.com:langenhagen/DBSCAN
    git clone git@github.com:langenhagen/dotfiles
    git clone git@github.com:langenhagen/evaluate-locs
    git clone git@github.com:langenhagen/experiments-and-tutorials
    git clone git@github.com:langenhagen/expertises-gantt
    git clone git@github.com:langenhagen/explore-with-dmenu
    git clone git@github.com:langenhagen/form3-challenge
    git clone git@github.com:langenhagen/fve
    git clone git@github.com:langenhagen/Illisha
    git clone git@github.com:langenhagen/Jet
    git clone git@github.com:langenhagen/langenhagen.github.io
    git clone git@github.com:langenhagen/Master-Thesis
    git clone git@github.com:langenhagen/momox-graphs
    git clone git@github.com:langenhagen/momox-investigate
    git clone git@github.com:langenhagen/momox-local-environment
    git clone git@github.com:langenhagen/momox-pyinvestigate
    git clone git@github.com:langenhagen/momox-scripts
    git clone git@github.com:langenhagen/nextcloud-server
    git clone git@github.com:langenhagen/omnimacro
    git clone git@github.com:langenhagen/OPTICS
    git clone git@github.com:langenhagen/ping-out
    git clone git@github.com:langenhagen/plot-on-off-logs
    git clone git@github.com:langenhagen/Processing
    git clone git@github.com:langenhagen/protofiles
    git clone git@github.com:langenhagen/recipes
    git clone git@github.com:langenhagen/reposet
    git clone git@github.com:langenhagen/scripts
    git clone git@github.com:langenhagen/setup-c1-ubuntu
    git clone git@github.com:langenhagen/setup-momox-ubuntu
    git clone git@github.com:langenhagen/setup-my-ubuntu
    git clone git@github.com:langenhagen/station-clock
    git clone git@github.com:langenhagen/tmStreamer
    git clone git@github.com:langenhagen/trip
    git clone git@github.com:langenhagen/wealth
    git clone git@github.com:langenhagen/xLayer
    git clone git@github.com:langenhagen/xpad-trigger
}

du -hs "$repo_dir"
