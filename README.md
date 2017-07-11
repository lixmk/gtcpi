# gtcpi - GTC Downgrade Attack
gtcpi is a set of scripts designed to setup and launch an evil-twin wireless access point using the GTC downgrade attack to capture plaintext 802.1x credentials, all on a Raspberry Pi 3. Using a Raspberry Pi allows the attack to be performed discreetly over a period of time. 
  
This project is based on the following previous works:
* https://www.defcon.org/images/defcon-21/dc-21-presentations/djwishbone-PuNk1nPo0p/DEFCON-21-djwishbone-PuNk1nPo0p-BYO-Disaster-Updated.pdf
* https://www.youtube.com/watch?v=-uqTqJwTFyU
* https://github.com/Torinson/lootbooty/blob/master/modules/peapingtom.rb
* https://github.com/ring0lab/Weaponry/tree/master/802.1x
  
For more information on how the attack works, check out the above links. Those folks did all the hard work, I just put it on a pi.    
  
# Installation  
gtcpi is designed to be installed on a Raspberry Pi 3 with Kali's Raspberry Pi build *as root*. The install can take a while as several things need to generate safe primes, and freeradius is patched and build from source. I strongly consider starting with an `apt-get install screen` and running the rest of the commands from a screen sessions, just in case.  

From a fresh Kali install, log on as root and:  
`cd /root/ && git clone https://github.com/lixmk/gtcpi`  
`cd gtcpi && setup.sh`  

That should do it. Everything should fire up on next boot.  
  
# Usage  
gtcpi uses the boot partition of the Pi's SD Card to determine the target SSID as well as pass captured credentials. This eliminates the need to interact with the Pi while it's booted. Simply remove the SD Card and access it using a computer. The boot partition should mount automatically.  
  
The file 'ssid' contains the target SSID ('gtcpi' by default). Simply change the contents of this file to reflect your target SSID.  
  
The 'gtcpi.csv' file contains a log of usernames and password previously captured. At boot, the previous gtcpi.csv file renamed to TIMESTAMP.gtcpi.csv. This is currently a very clunky mechanism which will either be improved or abandoned in the future.  
  
All service are launched at boot. No interaction is necessary. Power on, steal creds, power off.  
  
# Limitations  
There are several limitations in the current 'alpha' build.
1. gtcpi is not designed to forward traffic. Even if the ethernet port has connectivity, gtcpi clients will not.
2. Data exfiltration requires retriving the device and removing the SD card.
3. The current data exfiltration method (storing in boot partition) might lead to some problems, should the log file fill the entirety of the partition.
4. This does not use a karma style attack. It will only serve the SSID contained in the ssid file.
5. Timestamps will be inaccurate unless a hardware clock is added.
6. Additionally, Timestamps for gtcpi.csv only show the time of boot, not the time which the credentials were captured.
6. Something else I'm likely not thinking of at the moment.
