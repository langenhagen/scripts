#!/usr/bin/env python3
#
# Add a Ubuntu global schema_and_key shortcut via command line.
# Remap commands that already exist but share the same attribute 'name '.
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
# author: andreasl
# version: 18-12-17

import ast
import subprocess
import sys


def exec_bash_cmd(cmd):
    return subprocess.check_output(["/bin/bash", "-c", cmd]).decode("utf-8")


schema_and_key = "org.gnome.settings-daemon.plugins.media-keys custom-keybindings"
cmd = "gsettings get " + schema_and_key
shortcut_names = exec_bash_cmd(cmd).lstrip("@as").strip()

# iterate over all existing shortcuts to see if one with the same name already exists and reuse that
already_installed_shortcuts = ast.literal_eval(shortcut_names)
entry = None
for s in already_installed_shortcuts:

    check_name_cmd = 'gsettings get ' + \
        schema_and_key[:-1].replace(" ", ".") + ':' + s + ' name'
    shortcut_name = exec_bash_cmd(check_name_cmd)

    if shortcut_name.strip()[1:-1].lower() == sys.argv[1].lower():
        entry = s
        break


# if no shortcut with the given name exists, create a new one
schema_and_key_slash_separated = "/" + \
    schema_and_key.replace(" ", "/").replace(".", "/")
if not entry:
    entry = schema_and_key_slash_separated + "/custom1/"
    index = 2
    while entry in already_installed_shortcuts:
        entry = schema_and_key_slash_separated + "/custom" + str(index) + "/"
        index += 1
    already_installed_shortcuts.append(entry)
    append_entry_to_shortcuts_cmd = 'gsettings set ' + \
        schema_and_key + ' "' + str(already_installed_shortcuts) + '"'
    exec_bash_cmd(append_entry_to_shortcuts_cmd)


subkey_and_entry = schema_and_key[:-1].replace(" ", ".") + ":" + entry

# to create the shortcut, set the name, command and shortcut schema_and_key
set_name_cmd    = 'gsettings set ' + subkey_and_entry + " name '"    + sys.argv[1] + "'"
set_command_cmd = 'gsettings set ' + subkey_and_entry + " command '" + sys.argv[2] + "'"
set_binding_cmd = 'gsettings set ' + subkey_and_entry + " binding '" + sys.argv[3] + "'"

for cmd in [set_name_cmd, set_command_cmd, set_binding_cmd]:
    print(" +  {}".format(cmd))
    exec_bash_cmd(cmd)
