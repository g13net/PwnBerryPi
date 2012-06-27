#!/bin/bash
# PwnBerryPi - Pentesting Suite for Raspberry Pi
# g13net.com


echo ""

# Verify we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Verify PwnBerryPi  is not already installed
if [ "`grep -o 0.1 /etc/motd.tail`" == "1.0" ] ; then 
        echo "[-] PwnBerryPi already installed. Aborting..."
        exit 1
fi

echo ""
echo " PwnBerry Pi - 1.0 "
echo ""
echo " This installer will load a comprehensive security pentesting   "
echo " software suite onto your Raspberry Pi. Note that the Debian    "
echo " Raspberry Pi distribution must be installed onto the SD card   "
echo " before proceeding. See README.txt for more information.       "
echo ""
echo " Warning: This install process will take quite a long time.  "
echo " Please do not interrupt it!"
echo ""
echo "Press ENTER to continue, CTRL+C to abort."
read INPUT
echo ""



# Make sure all installer files are owned by root
chown -R root:root .

# Update base debian packages
echo "[+] Updating base system Debian packages..."
echo "deb http://ftp.debian.org/debian/ squeeze main contrib non-free" > /etc/apt/sources.list
aptitude -y update
aptitude -y upgrade
echo "[+] Base system Debian packages updated."

# Install baseline pentesting tools via aptitude
echo "[+] Installing baseline pentesting tools/dependencies..."
aptitude -y install  vim telnet btscanner libnet-dns-perl hostapd nmap dsniff netcat nikto xprobe python-scapy wireshark tcpdump ettercap hping3 medusa macchanger nbtscan john ptunnel p0f ngrep tcpflow openvpn iodine httptunnel cryptcat sipsak yersinia smbclient sslsniff tcptraceroute pbnj netdiscover netmask udptunnel dnstracer sslscan medusa ipcalc dnswalk socat onesixtyone tinyproxy dmitry fcrackzip ssldump fping ike-scan gpsd darkstat swaks arping tcpreplay sipcrack proxychains proxytunnel siege sqlmap wapiti skipfish w3af libssl-dev libpcap-dev libpcre3 libpcre3-dev libnl-dev libncurses-dev subversion python-twisted-web python-pymssql
echo "[+] Baseline pentesting tools installed."

# Remove unneeded statup items
echo "[+] Remove unneeded startup items..."
update-rc.d -f gpsd remove
update-rc.d -f tinyproxy remove
update-rc.d -f ntp remove
apt-get -y purge portmap
apt-get -y autoremove gdm
apt-get -y autoremove
echo "[+] Unneeded startup items removed."

# Install wireless pentesting tools
echo "[+] Installing wireless pentesting tools..."
aptitude -y install kismet
cd src/aircrack-ng-1.1
chmod +x evalrev
make install
cd ../..
echo "[+] Wireless pentesting tools installed."

# Install Metasploit
echo "[+] Installing latest Metasploit Framework..."
# Setting more RAM available for Metasploit
echo ""
echo "[+] Changing RAM to 224/32 Split"
cp /boot/arm224_start.elf /boot/start.elf
aptitude -y install ruby irb ri rubygems libruby ruby-dev libpcap-dev
mkdir /opt/metasploit
cd /opt/metasploit
wget http://downloads.metasploit.com/data/releases/framework-latest.tar.bz2
tar jxvf framework-latest.tar.bz2
ln -sf /opt/metasploit/msf3/msf* /usr/local/bin/
echo "[+] Latest Metasploit Framework installed."

# Install Perl/Python tools to /pentest
echo "[+] Installing Perl/Python tools to /pentest..."
cp -a src/pentest/ /
chown -R root:root /pentest/
chmod +x /pentest/cisco-auditing-tool/CAT
chmod +x /pentest/easy-creds/easy-creds.sh
chmod +x /pentest/goohost/goohost.sh
chmod +x /pentest/lbd/lbd.sh
chmod +x /pentest/sslstrip/sslstrip.py
echo "[+] Perl/Python tools installed in /pentest."

# Install SET
echo "[+] Installing latest SET framework to /pentest..."
svn co http://svn.secmaniac.com/social_engineering_toolkit /pentest/set/
cd src/pexpect-2.3/
python setup.py install
cd ../..
echo "[+] SET framework installed in /pentest."

# Install Exploit-DB
echo "[+] Installing Exploit-DB to /pentest..."
svn co svn://www.exploit-db.com/exploitdb /pentest/exploitdb/
echo "[+] Exploit-DB installed in /pentest."

# Update motd to show Raspberry Pwn release
cp src/motd.tail.pwnberrypi /etc/motd.tail

#change hostname
cp /etc/hosts src/hosts.old
cp src/hosts.pwnberrypi /etc/hosts


echo ""
echo "---------------------------------------------------------------"
echo "PwnBerryPi Release 1.0 installed successfully!"
echo "---------------------------------------------------------------"
echo ""
exit 1
