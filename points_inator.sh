#!/bin/bash
# This will only work with Debian, for the love of god do not run on arch!!

echo "Doing the APT shenanigans..."

# Fix stupid apt issues caused by foxes that are on fire
echo 'deb http://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu/ jammy main' > /etc/apt/sources.list.d/mozillateam-ubuntu-ppa-jammy.list

while true; do
    read -p "Is 'apache2' or 'apache' a critical service? (will be in readme) [Y/N " yn
    case $yn in
        [Yy]* ) apt purge apache2; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Do some of the dirty work now that APT is working & Do firewall for easy points
capt purge aisleriot wireshark ophcrack nmap nginx john hydra; sudo apt install ftp vsftpd gufw ssh
echo "Please enable the firewall"
gufw

chmod 640 /etc/shadow

echo "password requisite pam_cracklib.so retry=3 minlen=8 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1 dictpath=/usr/share/dict/words" >> /etc/pam.d/common-password

echo "PermitRootLogin no" >> /etc/ssh/sshd_config
# Copy templates to directories :3
cp ./ssh_donotremove.template /etc/ssh/sshd_config
cp ./login.defs.template /etc/login.defs
cp ./10periodic.template /etc/apt/apt.conf.d/10periodic

echo "net.ipv4.tcp_syncookies=0" > /etc/sysctl.conf
echo "net.ipv4.ip_forward=0" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.forwarding=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.log_martians=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_source_route=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_redirects=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.proxy_arp=0" >> /etc/sysctl.conf
sysctl -p
# Remove all .mp3s and jpgs from /home recursively
find /home -type f -name "*.mp3" -exec rm -f {} \;
find /home -type f -name "*.jpg" -exec rm -f {} \;

apt update
apt upgrade


