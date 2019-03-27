#!/bin/bash
#
# Launches a Jupyter Lab instance at the given path.
# If this is the first instance, also shows a dialog window.
# When the Button 'OK' on this dialog is pressed, all running jupyter-lab instances will be killed.
#
# author: andreasl

cd "${*:-.}" || exit 1

function on_exit {
    # start sentinel if sentinel is missing
    message="Press OK to shutdown all Jupyter Lab instances."
    sentinel_pid="$(pgrep -f "zenity --info --width 350 --text=$message")"
    if [ -z "$sentinel_pid" ]; then
        zenity --info --width 350 --text="$message";
        pkill jupyter-lab
    fi
}

trap on_exit EXIT

. $HOME/miniconda3/etc/profile.d/conda.sh
conda activate my
jupyter lab&