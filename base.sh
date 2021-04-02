#!/bin/bash
# Base Debian 10 installation script

echo "[*] Installing base packages..."
sleep 2
sudo apt update && sudo apt install software-properties-common \
apt-transport-https curl jq gnupg aptitude vim open-vm-tools \
open-vm-tools-desktop firefox-esr dnsutils mupdf ufw gftp git \
gparted gzip hexchat htop geany p7zip remmina telnet tmux thunar \
thunar-archive-plugin traceroute rkhunter transmission unzip \
unrar vim wget wireshark-gtk proxychains-ng tor ristretto chromium \
code bless python3 ufw openssh-server papirus-icon-theme \
fonts-firacode fonts-font-awesome fonts-hack fonts-roboto \
fonts-dejavu fonts-dejavu-extra fonts-noto-color-emoji \
fonts-symbola xfonts-terminus pip -y

sudo pip3 install pywal

echo "[*] Adding gpg key for microsoft..."
sleep 2
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

echo "[*] Configuring ufw..."
sleep 2
sudo ufw default deny incoming
sudo ufw allow in on lo
sudo ufw allow out from lo
sudo ufw deny in from 127.0.0.0/8
sudo ufw deny in from ::1
echo "y" | sudo ufw enable

echo "[*] Locking down home, crontab and removing unnecessary users and groups"
sleep 2
sudo chmod -R 750 $HOME
sudo groupdel audio
sudo groupdel video
sudo userdel irc
sudo userdel uucp
sudo userdel news
sudo groupdel news
sudo userdel games
sudo userdel list
sudo rmdir /usr/local/games
sudo chmod og-rwx /etc/crontab
sudo chown root:root /etc/crontab
sudo chmod og-rwx /etc/cron.*
sudo chown root:root /etc/cron.*
sudo rm /etc/cron.deny 
sudo touch /etc/cron.allow
sudo chown root:root /etc/cron.allow
sudo chmod g-wx,o-rwx /etc/cron.allow

echo "[*] Locking down ssh files..."
sleep 2
sudo chown root:root /etc/ssh/sshd_config
sudo chmod og-rwx /etc/ssh/sshd_config
sudo find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:root {} \;
sudo find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod 0600 {} \;
sudo find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod go-wx {} \;
sudo find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \;

echo "[*] Blacklisting unneeded kernel modules"
sleep 2
echo "blacklist aesni_intel" | sudo tee /etc/modprobe.d/aesni_intel.conf
echo "blacklist bluetooth" | sudo tee /etc/modprobe.d/bluetooth.conf
echo "blacklist btbcm" | sudo tee /etc/modprobe.d/btbcm.conf
echo "blacklist btintel" | sudo tee /etc/modprobe.d/btintel.conf
echo "blacklist btrtl" | sudo tee /etc/modprobe.d/btrtl.conf
echo "blacklist btusb" | sudo tee /etc/modprobe.d/btusb.conf
echo "blacklist ehci_hcd" | sudo tee /etc/modprobe.d/ehci_hcd.conf
echo "blacklist uhci_hcd" | sudo tee /etc/modprobe.d/uhci_hcd.conf
echo "blacklist usb_common" | sudo tee /etc/modprobe.d/usb_common.conf
echo "blacklist usbcore" | sudo tee /etc/modprobe.d/usbcore.conf
sudo depmod -ae
sudo update-initramfs -u

echo "[*] Making backup of sshd_config..."
sleep 2
if [  ! -f  /etc/ssh/sshd_config_old ];then
    
    sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config_old

    echo "[*] Creating new sshd_config..."

cat <<"EOF" | sudo tee /etc/ssh/sshd_config
Include /etc/ssh/sshd_config.d/*.conf
MaxAuthTries 6
Protocol 2
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding no
PrintMotd no
AcceptEnv LANG LC_*
HostbasedAuthentication no
PermitRootLogin no
PermitEmptyPasswords no
PermitUserEnvironment no
AllowTcpForwarding no
Subsystem	sftp	/usr/lib/openssh/sftp-server
EOF

fi

echo "[*] Making backup of sysctl.conf..."
sleep 2
if [  ! -f  /etc/sysctl.conf_old ];then
    
    sudo cp /etc/sysctl.conf /etc/sysctl.conf_old

    echo "[*] Updating sysctl.conf..."

cat <<EOF | sudo tee -a /etc/sysctl.conf
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_source_route=0
net.ipv4.conf.default.accept_source_route=0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0 
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0 
net.ipv4.conf.all.log_martians=1
net.ipv4.conf.default.log_martians=1
net.ipv4.icmp_echo_ignore_broadcasts=1
net.ipv4.icmp_ignore_bogus_error_responses=1
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1
net.ipv4.tcp_syncookies=1
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.default.accept_ra = 0
EOF

fi

sudo sysctl -w net.ipv4.conf.all.send_redirects=0
sudo sysctl -w net.ipv4.conf.default.send_redirects=0
sudo sysctl -w net.ipv4.conf.all.accept_source_route=0
sudo sysctl -w net.ipv4.conf.default.accept_source_route=0
sudo sysctl -w net.ipv4.conf.all.accept_redirects=0
sudo sysctl -w net.ipv4.conf.default.accept_redirects=0 
sudo sysctl -w net.ipv4.conf.all.secure_redirects=0
sudo sysctl -w net.ipv4.conf.default.secure_redirects=0 
sudo sysctl -w net.ipv4.conf.all.log_martians=1
sudo sysctl -w net.ipv4.conf.default.log_martians=1
sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sudo sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sudo sysctl -w net.ipv4.conf.all.rp_filter=1
sudo sysctl -w net.ipv4.conf.default.rp_filter=1
sudo sysctl -w net.ipv4.tcp_syncookies=1
sudo sysctl -w net.ipv6.conf.all.accept_ra=0
sudo sysctl -w net.ipv6.conf.default.accept_ra=0
sudo sysctl -w net.ipv4.route.flush=1

# Not sure if needed
# echo "install dccp /bin/true" > /etc/modprobe.d/dccp.conf
# echo "install sctp /bin/true" > /etc/modprobe.d/sctp.conf
# echo "install rds /bin/true" >  /etc/modprobe.d/rds.conf
# echo "install tipc /bin/true" > /etc/modprobe.d/tipc.conf
