#!/bin/bash
#
# Launches a Jupyter Lab instance at the given path.
# If this is the first instance, also shows a dialog window.
# When the Button 'OK' is pressed on this dialog, all running jupyter-lab instances will be killed.
#
# author: andreasl

cd "${*:-.}" || exit 1

function on_exit {
    # start sentinel if sentinel is missing
    sentinel_pid="$(pgrep -f "zenity --info --width 350 --text=Press OK to shutdown all Jupyter Lab instances.")"
    if [ -z "$sentinel_pid" ]; then
        zenity --info --width 350 --text='Press OK to shutdown all Jupyter Lab instances.';
        jupyter_pids="$(pgrep 'jupyter-lab')"
        kill $jupyter_pids
    fi
}

trap on_exit EXIT

IFS= read -r -d '' fish_code << EOF
conda activate my
jupyter lab&
EOF

fish -c "${fish_code}"