#!/bin/bash
MEE=$USER
downs=/home/$MEE/Downloads
read -p "Please select: deb, rpm, zyp" spin

su -c 'mkdir /etc/myScripts ; mv $downs/Linux/* /etc/myScripts'

su -c 'touch .bash_aliases'
su -c 'echo #!/bin/bash >> .bash_aliases'
su -c 'echo " " >> .bash_aliases'

touch /etc/myScripts/spin.txt
su -c 'echo $spin >> /etc/myScripts/spin.txt'

if [ $spin -eq 'deb']; then
	su -c "echo alias updater='/etc/myScripts/debUpdater' >> .bash_aliases"
elif [$spin -eq 'rpm']; then
  su -c "echo alias updater='/etc/myScripts/rpmUpdater' >> .bash_aliases"
elif [$spin -eq 'zyp']; then
  su -c "echo alias updater='/etc/myScripts/zypUpdater' >> .bash_aliases"
fi

echo "Be sure to fix the .bash_aliases fqpath"
