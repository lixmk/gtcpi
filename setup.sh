#!/bin/bash
# Updating Packages

# Confirm user and dir are "root"
# Not implemented yet, fixing broken things first

echo -e "\e[31m[*] Updating apt-get.\e[0m"
apt-get update -y

# Installing required packages for build
echo -e "\e[31m[*] Installing requirements. Go get a beer (or coffee).\e[0m"
apt-get install -y make patch gcc hostapd net-tools screen libfreeradius3 libfreeradius-dev libssl1.0-dev openssl

# Installing FreeRadius and Patch
echo -e "\e[31m[*] Extracting, patching, and building freeradius. Go get another beer (or coffee).\e[0m"
cp /root/gtcpi/tools/freeradius-server-2.1.12.tar.gz /opt/
cp /root/gtcpi/tools/PuNk1n.patch /opt/
cd /opt/ && tar -xvzf freeradius-server-2.1.12.tar.gz
cd /opt/freeradius-server-2.1.12/ && patch -p1 < ../PuNk1n.patch
cd /opt/freeradius-server-2.1.12/ && ./configure && make && make install
ldconfig
cd /usr/local/etc/raddb/certs/ && make

# Returning to gtcpi
cd /root/gtcpi/
mkdir logs

# Making boot partition mount on boot
echo -e "\e[31m[*] Configuring execution and boot and some other stuff.\e[0m"
sed -i 's/noauto/auto/' /etc/fstab

# Creating first "ssid" file
mount /dev/mmcblk0p1 /mnt/
sleep 1
echo "gtcpi" > /mnt/ssid
umount /mnt/

# Enabling rc.local
cp /root/gtcpi/conf/rc-local.service /etc/systemd/system/rc-local.service
cp /root/gtcpi/conf/rc.local /etc/
systemctl enable rc-local

# Configuring MitM
# This isn't a thing yet. Clients won't have connectivity for now

# Configuring exfil
# This also isn't a thing yet. Short term fix is to put the parsed log file in the boot partition for easy access

echo -e "\e[31m[*] Installation Complete.\e[0m"
echo -e "\e[31m[*] Check README.md for details on modifying the served SSID and retrieving captured creds.\e[0m"
echo -e "\e[31m[*] Remember, clients have no network access.\e[0m"
echo -e "\e[31m[*] All should function automatically on reboot.\e[0m"

