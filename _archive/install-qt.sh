#!/usr/bin/env bash
# Download and install QT and its prerequisites.
sudo apt update;
sudo apt upgrade -y;

sudo apt-get install build-essential libgl1-mesa-dev;  # basic QT requirements

sudo apt install -y qtcreator;
sudo apt install -y qt5-default;  # set QT 5 as the default

sudo apt install -y qt5-doc:  # Qt 5 API Documentation.
sudo apt install -y qtbase5-examples;  # Qt Base 5 examples.
sudo apt install -y qtbase5-doc-html;  # HTML documentation for the Qt 5 Base libraries
