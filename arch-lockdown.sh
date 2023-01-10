# Description: Arch linux hardening script. For use with desktop installs
#
# Full guide can be found here:
# https://theprivacyguide1.github.io/linux_hardening_guide
#

echo "[*] Making backup of sysctl.conf..."
sleep 2
if [  ! -f  /etc/sysctl.conf_old ];then
    
    sudo cp /etc/sysctl.conf /etc/sysctl.conf_old

    echo "[*] Updating sysctl.conf..."

echo <<EOF | sudo tee -a /etc/sysctl.d/kernel_hardening.conf
kernel.kptr_restrict=2 
kernel.dmesg_restrict=1
kernel.unprivileged_bpf_disabled=1
net.core.bpf_jit_harden=2
kernel.yama.ptrace_scope=2
kernel.kexec_load_disabled=1
net.ipv4.tcp_syncookies=1 
net.ipv4.tcp_rfc1337=1
net.ipv4.conf.default.rp_filter=1
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.default.accept_redirects=0
net.ipv4.conf.all.secure_redirects=0
net.ipv4.conf.default.secure_redirects=0
net.ipv6.conf.all.accept_redirects=0
net.ipv6.conf.default.accept_redirects=0 
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.default.accept_redirects=0
net.ipv4.conf.all.secure_redirects=0
net.ipv4.conf.default.secure_redirects=0
net.ipv6.conf.all.accept_redirects=0
net.ipv6.conf.default.accept_redirects=0 
net.ipv4.icmp_echo_ignore_all=1 
vm.mmap_rnd_bits=32
vm.mmap_rnd_compat_bits=16 
kernel.sysrq=0 
kernel.unprivileged_userns_clone=0 
net.ipv4.tcp_sack=0 
fs.suid_dumpable=0 
EOF

fi


echo "[*] Setting IPv6 privacy extensions..."
echo <<EOF | sudo tee -a /etc/sysctl/ipv6_privacy.conf 
net.ipv6.conf.all.use_tempaddr = 2
net.ipv6.conf.default.use_tempaddr = 2
net.ipv6.conf.enp7s0f4u1u3u3.use_tempaddr = 2
net.ipv6.conf.wlp3s0.use_tempaddr = 2 
net.ipv6.conf.enp5s0.use_tempaddr = 2 
net.ipv6.conf.enp2s0f0.use_tempaddr = 2 
EOF


echo "options nf_conntrack nf_conntrack_helper=0" | sudo tee -a /etc/modprobe.d/no-conntrack-helper.conf

# /etc/securetty tells the system where you are allowed to login as root. You should keep this file empty so nobody can login as root from a tty. 
echo "[*] Creating empty /etc/securetty..."
echo "" | sudo tee -a /etc/securetty

echo "[*] enabling privacy extensions for NetworkManager..."
echo <<EOF | sudo tee -a /etc/NetworkManager/NetworkManager.conf

[connection]
ipv6.ip6-privacy=2

[Network]
IPv6PrivacyExtensions=kernel
EOF

echo "[*] Blacklisting uncommon network protocols"
echo <<EOF | sudo tee -a /etc/modprobe.d/uncommon-network-protocols.conf
install dccp /bin/true
install sctp /bin/true
install rds /bin/true
install tipc /bin/true
install n-hdlc /bin/true
install ax25 /bin/true
install netrom /bin/true
install x25 /bin/true
install rose /bin/true
install decnet /bin/true
install econet /bin/true
install af_802154 /bin/true
install ipx /bin/true
install appletalk /bin/true
install psnap /bin/true
install p8023 /bin/true
install llc /bin/true
install p8022 /bin/true 
EOF

echo "[*] Disabling ability to  mount uncommon filesystems..."
echo <<EOF | sudo tee -a /etc/modprobe.d/uncommon-filesystems.conf
install cramfs /bin/true
install freevxfs /bin/true
install jffs2 /bin/true
install hfs /bin/true
install hfsplus /bin/true
install squashfs /bin/true
install udf /bin/true 
EOF

echo "[*] Locking the root account to prevent anyone from logging in as root..."
sudo passwd -l root

echo "[*] Configuring ufw..."
sleep 2
sudo ufw default deny incoming
sudo ufw allow in on lo
sudo ufw allow out from lo
sudo ufw deny in from 127.0.0.0/8
sudo ufw deny in from ::1
echo "y" | sudo ufw enable
sudo systemctl enable ufw

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
