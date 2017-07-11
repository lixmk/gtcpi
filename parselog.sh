#!/bin/bash
mv /boot/gtcpi.csv /boot/$(date -u '+%Y%m%dT%H%M%SZ').gtcpi.csv 2>/dev/null 
echo "SSID,Time,Date,Username,Password" >> /boot/gtcpi.csv
tail -f /root/gtcpi/logs/radius.log | egrep --line-buffered "(login attempt with password|Identity -)" | stdbuf -o0 cut -d '-' -f 2 | stdbuf -o0 sed 's/ /,/' | stdbuf -o0 sed 's/"/,/' | stdbuf -o0 cut -d " " -f 5 | stdbuf -o0 tr '\n' '\0' | stdbuf -o0 tr '"' '\n' | stdbuf -o0 sed "s#^#$(cat /boot/ssid),$(date +%T","%F)#" | tee -a /boot/gtcpi.csv
