#!/bin/sh
echo "Refreshing hostapd config";
cp /root/gtcpi/conf/hostapd.conf.bak /root/gtcpi/conf/hostapd.conf;
echo "Changing SSID to $(cat /boot/ssid)";
sed -i "s/ssid=gtcpi/ssid=$(cat /boot/ssid)/" /root/gtcpi/conf/hostapd.conf;
echo "Making sure wlan0 is gtg";
ifconfig wlan0 down;
nmcli n off && rfkill unblock all && ifconfig wlan0 up;
sleep 2;
echo "Bringing up hostapd"
screen -dmS hostapd -m hostapd /root/gtcpi/conf/hostapd.conf;
sleep 2;
echo "Bringing up radiusd"
rm /root/gtcpi/logs/radius.log
screen -dmS radiusd -m radiusd -X -l /root/gtcpi/logs/radius.log -d /root/gtcpi/conf/raddb;
sleep 2;
echo "Brining up logging"
screen -dmS logs -m /root/gtcpi/parselog.sh
sleep 2;
echo "Verifying..."
screen -ls
exit 0
