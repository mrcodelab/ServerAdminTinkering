#!/bin/bash

read -p "What's the new version number?" $ver
sudo dnf up -y
sudo dnf upgrade --refresh
sudo dnf install -y dnf-plugin-upgrade
sudo dnf system-upgrade download --releasever=$ver
sudo dnf system-upgrade reboot