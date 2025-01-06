#!/bin/bash
# Launch a Jupyter Lab instance at the given path.
# If this is the first instance, also show a dialog window.
# When the user presses the Button 'OK' on this dialog, kill all running jupyter-lab instances.
#
# author: andreasl

cd "${*:-.}" || exit 1

on_exit() {
    # start s sentinel if a sentinel is yet missing
    message="Press OK to shutdown all Jupyter Lab instances."
    sentinel_pid="$(pgrep -f "zenity --info --width 350 --text=$message")"
    if [ -z "$sentinel_pid" ]; then
        zenity --info --width 350 --text="$message";
        pkill jupyter-lab
    fi
}
trap on_exit EXIT

source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate my
jupyter lab&
