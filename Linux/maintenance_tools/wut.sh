#!/bin/bash

echo "What are you here for? Update: 0| GUI: 1| Term: 2"
read -p 'wut up?' pickle

updater() {
	sudo dnf update -y
}

if [ $pickle = 0 ]; then
	updater
	init 0
elif [ $pickle = 1 ]; then
	systemctl set-default runlevel5.target
	init 6
elif [ $pickle = 2 ]; then
	updater
	#./scripts/syncer.sh
	systemctl set-default runlevel3.target
	init 0
fi
