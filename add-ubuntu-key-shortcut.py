#!/usr/bin/env python3
#
# Add a Ubuntu global schema_and_key shortcut via command line.
#
# Usage:
#   python3 $0 <command name> <command> <schema_and_key-kombination>
#
# Example:
#   python3 $0 'open gedit' 'gedit' '<Alt>7'
#
# Special keys are: <Ctrl>, <Alt>, <Super>.
#
# based on:
# https://askubuntu.com/questions/597395/how-to-set-custom-keyboard-shortcuts-from-terminal
#
#
# TODO: remove a command that already has the given key-combination.
#
# author: andreasl
# version: 18-12-01

import ast
import subprocess
import sys

def get_list_from_cmd_output(cmd):
    """Get the list-output of a bash command that looks as a python list.
    In case the list was empty, remove the annotation hints '@as'.
    """
    list_as_string = subprocess.check_output(["/bin/bash", "-c", cmd]).decode("utf-8").lstrip("@as")
    return ast.literal_eval(list_as_string)


schema_and_key = "org.gnome.settings-daemon.plugins.media-keys custom-keybindings"
schema_and_key_slash_separated = "/" + schema_and_key.replace(" ", "/").replace(".", "/")
already_installed_custom_shortcuts = get_list_from_cmd_output("gsettings get " + schema_and_key)

# make sure the additional keybinding mention gets a new index
index = 1
while True:
    new_entry = schema_and_key_slash_separated + "/" + "custom" + str(index) + "/"
    if new_entry in already_installed_custom_shortcuts:
        index = index + 1
    else:
        break

subkey = schema_and_key.replace(" ", ".")[:-1] + ":"
already_installed_custom_shortcuts.append(new_entry)
# to create the shortcut, set the name, command and shortcut schema_and_key
cmd0 = 'gsettings set ' + schema_and_key + ' "' + str(already_installed_custom_shortcuts) + '"'
cmd1 = 'gsettings set ' + subkey + new_entry + " name '" + sys.argv[1] + "'"
cmd2 = 'gsettings set ' + subkey + new_entry + " command '" + sys.argv[2] + "'"
cmd3 = 'gsettings set ' + subkey + new_entry + " binding '" + sys.argv[3] + "'"

for cmd in [cmd0, cmd1, cmd2, cmd3]:
    print(" +  {}".format(cmd))
    subprocess.call(["/bin/bash", "-c", cmd])
