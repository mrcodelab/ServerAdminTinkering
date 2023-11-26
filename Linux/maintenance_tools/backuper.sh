#!/bin/bash
logfile="/home/$USER/Documents/bkup.txt"

if [ ! -f $logfile ]; then
	touch $logfile
elif [ -f $logfile ]; then
	rm $logfile
	touch $logfile
fi

bkup(){
	sleep 5s
	source=$(hostname)
	datestmp=$(date +"%Y-%m-%d")
	fname="backup_"$source"_"$datestmp

	tar --exclude='github/*' --exclude='Downloads/*' --exclude='.*' -czvf ~/Downloads/$fname.tar.gz /home/$USER
	ls ~/Downloads/*.gz
	echo "backup completed" >> $logfile

#	scp ~/Downloads/$fname.tar.gz <path_to_cloud>:/home/DropBox/
#	echo "copy to offsite complete" >> $logfile
}
bkup
exit
