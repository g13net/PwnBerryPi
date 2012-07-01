#!/bin/bash
# PwnberryPi: A Pentesting Suite for the Raspberry Pi
# g13net.com

echo ""

# Verify we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo ""
echo "        === PwnberryPi Release 1.0 UNINSTALLER ===           "
echo ""
echo "----------------------------------------------------------------"
echo " This UNINSTALLER will remove the PwnberryPi pentesting      "
echo " software suite from your Raspberry Pi.                         "
echo ""
echo "Press ENTER to continue, CTRL+C to abort."
read INPUT
echo ""

echo "[+] Removing baseline pentesting tools/dependencies..."
aptitude -y remove vim telnet btscanner libnet-dns-perl hostapd nmap dsniff netcat nikto xprobe python-scapy wireshark tcpdump ettercap hping3 medusa macchanger nbtscan john ptunnel p0f ngrep tcpflow openvpn iodine httptunnel cryptcat sipsak yersinia smbclient sslsniff tcptraceroute pbnj netdiscover netmask udptunnel dnstracer sslscan medusa ipcalc dnswalk socat onesixtyone tinyproxy dmitry fcrackzip ssldump fping ike-scan gpsd darkstat swaks arping tcpreplay sipcrack proxychains proxytunnel siege wapiti skipfish w3af libssl-dev libpcap-dev libpcre3 libpcre3-dev libnl-dev libncurses-dev subversion python-twisted-web python-pymssql
echo "[+] Removing wireless pentesting tools..."
aptitude -y remove kismet
cd src/aircrack-ng-1.1
make uninstall
cd ../..

# Remove /pentest
echo "[+] Removing /pentest..."
rm -rf /pentest

echo "[+] Removing Metasploit"
rm -rf /opt/msf3
rm /usr/local/bin/msf*

# Restore original motd
cp src/motd.tail.original /etc/motd.tail

echo ""
echo "---------------------------------------------------------------"
echo "PwnberryPi 1.0 UNINSTALLED successfully!"
echo "---------------------------------------------------------------"
echo ""
exit 1
