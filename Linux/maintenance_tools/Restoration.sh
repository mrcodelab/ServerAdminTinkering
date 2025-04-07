#!/bin/bash

mkdir -p /opt/custom_scripts
touch /var/log/updater.log
custpth='/opt/custom_scripts'
sysdpth='/etc/systemd/system'

# Function to get OS info
get_os_info() {
    local os_type="Unknown"
    local version="Unknown"

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        os_type=$NAME
        version=$VERSION_ID
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        os_type=$DISTRIB_ID
        version=$DISTRIB_RELEASE
    elif [ -f /etc/redhat-release ]; then
        os_type=$(cat /etc/redhat-release | awk '{print $1}')
        version=$(cat /etc/redhat-release | awk '{print $3}')
    fi

    echo "$os_type|$version"
}

# Get OS info
IFS='|' read -r OS_TYPE VERSION <<< "$(get_os_info)"

# Convert OS_TYPE to lowercase for case matching
OS_TYPE_LOWER=$(echo "$OS_TYPE" | tr '[:upper:]' '[:lower:]')

adtlpkg=("nano" "aide" "fapolicyd" "openscap" "scap-workbench" "keepassxc" "fail2ban" "p7zip"\
        "policycoreutils-gui" "setools-gui" "setools" "setools-console" "selinux-policy" "createrepo" "genisoimage"\
		"realmd" "samba" "samba-winbind" "samba-winbind-clients" "samba-common" "samba-common-tools"\
		"samba-winbind-krb5-locator" "oddjob" "oddjob-mkhomedir" "krb5-workstation")

# Write updater.sh for rpm to string variable
rpm_update=$(cat << 'EOF'
#!/bin/bash'

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
#!/bin/bash'

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

# Function to install EPEL
install_epel() {
    case "$OS_TYPE_LOWER" in
        "almalinux")
            echo "Detected AlmaLinux $VERSION"
            echo "Installing EPEL for AlmaLinux..."
            sudo dnf install -y epel-release
            sudo dnf install -y @virtualization
            sudo dnf remove -y firefox*
            ;;
        "red hat enterprise linux"|"rhel")
            if [[ "$VERSION" =~ ^9 ]]; then
                echo "Detected RHEL 9.x"
                echo "Installing EPEL for RHEL 9..."
                sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
            else
                echo "RHEL version $VERSION not supported for EPEL in this script"
            fi
            ;;
        "fedora linux")
            echo "Detected Fedora Linux $VERSION"
            echo "Fedora already includes many EPEL packages in its default repos"
            # Since Fedora includes most everything you'd need from EPEL, this is more of an emulated try block
            echo "Installing EPEL for Fedora..."
            sudo dnf install -y epel-release
            sudo dnf install -y @virtualization
            sudo dnf remove -y pidgin hexchat firefox*
            ;;
        "debian gnu/linux")
            if [ "$VERSION" = "12" ]; then
                echo "Detected Debian 12"
                echo "EPEL is for RPM-based systems; Debian uses APT"
                echo "No EPEL equivalent needed - Debian 12 has extensive default repos"
            else
                echo "Debian version $VERSION not matched to 12"
            fi
            ;;
        *)
            echo "OS $OS_TYPE version $VERSION not matched for EPEL installation"
            ;;
    esac
}

# Execute the installation function
install_epel "$OS_TYPE_LOWER"

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

cat <<EOF > /etc/logrotate.d/updaterprovide an example of a bash variable that is a multi-lineprov string
/var/log/updater.log {
	missingok
	create 0644 root root
	monthly
	rotate 2
	compress
}
EOF
echo "logrotate is setup"

sudo chmod 755 $custpth/*
sudo chmod 755 $sysdpth/updater.*
sudo chmod 644 /var/log/updater.log
systemctl enable updater.service

cat <<EOF > $custpth/pre-repo-pull.txt
#!/bin/bash
#configs for repo-pull
sudo chmod +x /opt/custom_scripts/repopull.sh
sudo systemctl daemon-reload
sudo systemctl enable repopull.timer
sudo systemctl start repopull.timer
EOF

cat << EOF > "$custpth/file_verifier.sh"
#!/bin/bash

read -p "Enter the path to file 1: " file1
read -p "Enter the path to file 2: " file2

hash1=$(md5sum "$file1" | awk '{print $1}')
hash2=$(md5sum "$file2" | awk '{print $1}')

if [ "$hash1" = "$hash2" ]; then
	echo "Files are the same"
else
	echo "Files are not the same"
fi
EOF

cat << EOF > "$custpth/sha256_verifier.sh"
#!/bin/bash

read -p "Enter path to file 1: " file1
read -p "Enter source hash in SHA256 for the downloaded file: \n" hash2


# Calculate the SHA256 hash for both files
hash1=$(sha256sum "$file1" | cut -d' ' -f1)
#hash2=$(sha256sum "$1" | cut -d' ' -f1)

echo "$hash1"

# Compare the hashes
if [ "$hash1" == "$hash2" ]; then
    echo "The files are identical."
else
    echo "The files are different."
fi
EOF

curl -fsS https://dl.brave.com/install.sh | sh
echo "${adtlpkg[@]}"
case "$OS_TYPE_LOWER" in
        "debian gnu/linux")
            sudo printf "$deb_update" | tee -a $custpth/updater.sh
			sudo apt install -y ${adtlpkg[@]}
			sudo bash /opt/custom_scripts/updater.sh
		;;
        *)
			sudo printf "$rpm_update" | tee -a $custpth/updater.sh
            dnf install -y ${adtlpkg[@]}
			dnf up -y            
            ;;
esac
reboot
#exit
