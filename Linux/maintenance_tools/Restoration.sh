#!/bin/bash

mkdir -p /opt/custom_scripts
touch /var/log/updater.log
custpth='/opt/custom_scripts'
sysdpth='/etc/systemd/system'

adtlpkg=("nano" "aide" "fapolicyd" "openscap" "scap-workbench" "keepassxc" "fail2ban" "p7zip"\
        "policycoreutils-gui" "setools-gui" "setools" "setools-console" "selinux-policy" "createrepo" "genisoimage"\
		"realmd" "samba" "samba-winbind" "samba-winbind-clients" "samba-common" "samba-common-tools"\
		"samba-winbind-krb5-locator" "oddjob" "oddjob-mkhomedir" "krb5-workstation")

# Write updater.sh for rpm to string variable
rpm_update=$(cat << 'EOF'
#!/bin/bash

exec_dt=$(date +"%Y%m%d")
logfile='/var/log/updater.log'

spacer(){
	echo "________________________________________________________________________" >> $logfile
	echo "________________________________________________________________________" >> $logfile
}
dnf up -y 2>&1 >> $logfile
pwck 2>&1 >> $logfile
echo "$exec_dt - system update and pwck completed." >> $logfile
spacer
exit
EOF
)

# Write udpater.sh for deb to string variable
deb_update=$(cat << 'EOF'
#!/bin/bash

exec_dt=$(date +"%Y%m%d")
logfile='/var/log/updater.log'

spacer(){
	echo "________________________________________________________________________" >> $logfile
	echo "________________________________________________________________________" >> $logfile
}

updt(){
	sudo apt-get update
	sudo apt-get upgrade --yes
	sudo apt update
	sudo apt full-upgrade --yes
	sudo apt autoclean
	sudo apt autoremove --yes
}

updt
pwck 2>&1 >> $logfile
echo "$exec_dt - system update and pwck completed." >> $logfile
spacer
exit
EOF
)

# Deploy files for all Linux systems
cat <<EOF > $sysdpth/updater.service
[Unit]
Description=Runs the updater tool.
Wants=updater.timer

[Service]
Type=oneshot
ExecStart=/opt/custom_scripts/updater.sh

[Install]
WantedBy=default.target
EOF
echo "updater.service setup"

cat <<EOF > $sysdpth/updater.timer
[Unit]
Description=Runs the updater tool daily.
Requires=updater.service

[Timer]
Persistent=true
OnCalendar=daily
Unit=updater.service

[Install]
WantedBy=timers.target
EOF
echo "updater.timer created"

cat <<EOF > /etc/logrotate.d/updater
/var/log/updater.log {
	missingok
	create 0644 root root
	monthly
	rotate 2
	compress
}
EOF
echo "logrotate is setup"

cat <<EOF > $custpth/pre-repo-pull.txt
#!/bin/bash
#configs for repo-pull
sudo chmod +x /opt/custom_scripts/repopull.sh
sudo systemctl daemon-reload
sudo systemctl enable repopull.timer
sudo systemctl start repopull.timer
EOF

{
    echo '#!/bin/bash'
    echo ''
    echo 'read -p "Enter the path to file 1: " file1'
    echo 'read -p "Enter the path to file 2: " file2'
    echo ''
    echo 'hash1=$(md5sum "$file1" | awk '{print $1}')'
    echo 'hash2=$(md5sum "$file2" | awk '{print $1}')'
    echo ''
    echo 'if [ "$hash1" = "$hash2" ]; then'
    echo -e	'\t echo "Files are the same"'
    echo 'else'
    echo -e	'\t echo "Files are not the same"'
    echo 'fi'
} > "$custpth/file_verifier.sh"

{
    echo '#!/bin/bash'
    echo 'read -p "Enter path to file 1: " file1'
    echo 'read -p "Enter source hash in SHA256 for the downloaded file: \n" hash2'
    echo ''
    echo '# Calculate the SHA256 hash for both files'
    echo 'hash1=$(sha256sum "$file1" | cut -d' ' -f1)'
    echo '#hash2=$(sha256sum "$1" | cut -d' ' -f1)'
    echo ''
    echo 'echo "$hash1"'
    echo ''
    echo '# Compare the hashes'
    echo 'if [ "$hash1" == "$hash2" ]; then'
        echo -e '\t echo "The files are identical."'
    echo 'else'
        echo -e '\t echo "The files are different."'
    echo 'fi'
} > "$custpth/sha256_verifier.sh"

curl -fsS https://dl.brave.com/install.sh | sh
echo "${adtlpkg[@]}"

# Distro specific tasks
get_os_info() {
    local os_type="Unknown"
    local version="Unknown"
    local is_debian_based="false"
    local is_rpm_based="false"

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        os_type=$NAME
        version=$VERSION_ID
        
        # Check if it's Debian-based
        if [ "${ID}" = "debian" ] || [[ "${ID_LIKE}" =~ "debian" ]]; then
            is_debian_based="true"
        fi
        
        # Check if it's RPM-based
        if [ "${ID}" = "fedora" ] || [ "${ID}" = "almalinux" ] || [ "${ID}" = "rhel" ] || [[ "${ID_LIKE}" =~ "rhel" ]] || [[ "${ID_LIKE}" =~ "fedora" ]]; then
            is_rpm_based="true"
        fi
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        os_type=$DISTRIB_ID
        version=$DISTRIB_RELEASE
        
        # Check if it's Debian-based
        if [ "${DISTRIB_ID}" = "Debian" ] || [ "${DISTRIB_ID}" = "Ubuntu" ] || [[ "${DISTRIB_ID}" == *"mint"* ]]; then
            is_debian_based="true"
        fi
    elif [ -f /etc/redhat-release ]; then
        os_type=$(cat /etc/redhat-release | awk '{print $1}')
        version=$(cat /etc/redhat-release | awk '{print $3}')
        is_rpm_based="true"
    fi

    if [ "$is_debian_based" = "true" ]; then
        echo "Debian-based|$version"
        echo "$deb_update" | tee $custpth/updater.sh > /dev/null
        sudo apt install -y ${adtlpkg[@]}
        sudo bash /opt/custom_scripts/updater.sh
    elif [ "$is_rpm_based" = "true" ]; then
        echo "RPM-based|$version"
        if [[ "${ID_LIKE}" =~ "rhel" ]]; then
            echo "Installing EPEL for RHEL 9..."
            sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
        fi
        sudo dnf install -y epel-release
        sudo dnf install -y @virtualization
        sudo dnf remove -y pidgin hexchat firefox*
        echo "$rpm_update" | tee $custpth/updater.sh > /dev/null
        dnf install -y ${adtlpkg[@]}
        dnf up -y
    else
        echo "$os_type|$version"
    fi
}

get_os_info
# # Get OS info
# IFS='|' read -r OS_TYPE VERSION <<< "$(get_os_info)"

# # Convert OS_TYPE to lowercase for case matching
# OS_TYPE_LOWER=$(echo "$OS_TYPE" | tr '[:upper:]' '[:lower:]')

sudo chmod -R 755 $custpth/*
sudo chmod -R 755 $sysdpth/updater.*
sudo chmod 644 /var/log/updater.log
systemctl enable updater.service

reboot
#exit
