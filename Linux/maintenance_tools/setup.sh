#!/bin/bash

updater=/etc/cron.daily/updater
read -p "Please select: deb, rpm, zyp" spin

su -c "echo 15 23 * * 6 root init 6 >> /etc/crontab"

if [ $spin -eq 'deb']; then
	su -c "echo #!/bin/bash > $updater"
  su -c "echo '' >> $updater"
  su -c "echo apt-get update; >> $updater"
  su -c "echo apt-get upgrade --yes; >> $updater"
  su -c "echo apt autoclean; >> $updater"
  su -c "echo apt autoremove --yes >> $updater"
elif [$spin -eq 'rpm']; then
  su -c "echo #!/bin/bash > $updater"
  su -c "echo '' >> $updater"
  su -c "echo dnf up -y >> $updater"
elif [$spin -eq 'zyp']; then
  su -c "echo #!/bin/bash > $updater"
  su -c "echo '' >> $updater"
  su -c "echo zypper update -y >> $updater"
fi
