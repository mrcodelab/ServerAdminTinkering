#!/bin/bash
logfile='/var/log/updater.log'
dt=$(date +'%Y%m%d-%H:%M')

spacer(){
	echo "___________________________________________________________________" >> $logfile
	echo "___________________________________________________________________" >> $logfile
}
dnf up -y 2>&1 >> $logfile
pwck 2>&1 >> $logfile
#freshclam 2>&1 >> $logfile
#aide --update >> $logfile
echo "$dt - system update and pwck completed" >> $logfile
spacer
exit
