#!/bin/bash
echo "I'm sorry you've had to use this again. Here we go"
read -p "Is the rpm or deb linux?" spin
read -p "how long do you think it'll take to download these?" timer

MEE=$USER
downs=/home/$MEE/Downloads
ins=/home/$MEE/Documents/instructions.txt

cleaner() {
	cd $downs
	rm -rf *.zip
	rm -rf *.tar.gz
	rm -rf *.rpm
}

clam() {
	if [ $spin == "deb" ]; then
		sudo apt-get install clamav clamav-daemon --yes
	else
		echo "clamav not available"
	fi
}


rpmTasks() {
	cd $downs
	wget "https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm"
	echo "The RealVNC package needs to be installed from the Gnome Software Tool"
	wget "https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-6.20.113-Linux-x64.rpm"
	sudo dnf install -y element.x86_64 --refresh
	sudo dnf install -y teamviewer* gparted \
						keybase.x86_64 atom.x86_64 brave-* keepassxc.x86_64 \
						tor.x86_64 torbrowser-launcher.x86_64 torsocks.x86_64 \
						mediawriter realvnc-vnc-viewer remmina \
	sleep $timer
	touch $ins
	sudo dnf up -y
	cleaner
	sudo init 6
}

debTasks() {
	wget "https://downloads.slack-edge.com/linux_releases/slack-desktop-4.4.3-amd64.deb"
	sudo apt install slack* --yes
	clam
	sudo apt autoclean
	sudo apt autoremove --yes
	sudo apt-get update
	sudo apt-get upgrade --yes
}

if [ $spin == "rpm" ]; then
	rpmTasks
elif [ $spin == "deb" ]; then
	debTasks
else
	echo "nothing to do"
	exit
fi
