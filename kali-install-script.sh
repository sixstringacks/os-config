############################################################################################
# Name: Kali Install Script
# Description: Installs packages from minmal kali image
#
# To Do:
# fix ghidra java issue
# add impacket tools to environment variable (autocomplete), what others need to be added?
# shell detection in script isn't working $0 = script name in script
# ngrok not in repo?
#
############################################################################################

#########################
## Prerequisites
#########################

# make sure we're in bash and make default
if [ $0 != "bash" ];then
    echo "[!] Needs to be run in bash! Exiting..."
    exit 1
fi

host="kali20230108"
tools_dir="/opt/tools/"
ghidra_url="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.2.2_build/ghidra_10.2.2_PUBLIC_20221115.zip"
chisel_url="https://github.com/jpillora/chisel/releases/download/v1.7.7/chisel_1.7.7_linux_amd64.gz"
sysinternals_url="https://download.sysinternals.com/files/SysinternalsSuite.zip"
namemash_url="https://gist.github.com/superkojiman/11076951/archive/74f3de7740acb197ecfa8340d07d3926a95e5d46.zip"
ngrok_url="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz"
kekeo_url="https://github.com/gentilkiwi/kekeo/releases/download/2.2.0-20211214/kekeo.zip"

# Set hostname and update /etc/hosts
sudo hostnamectl hostname $host
cat << EOF | sudo tee /etc/hosts
127.0.0.1       localhost
127.0.1.1       $(hostname)
EOF

#########################
## Software Installation
#########################

# Create tools directory and symlink
if [[ ! -d $tools_dir ]]; then
    sudo mkdir $tools_dir
    sudo chown -R six $tools_dir
    ln -s $tools_dir /home/six/tools
fi

echo "[*] Installing packages..."
sleep 2
sudo apt update && sudo apt install -y apt-transport-https binwalk bless build-essential burpsuite chromium \
crackmapexec crunch cewl curl dirb dirbuster dnsutils dmitry dos2unix edb-debugger enum4linux evil-winrm \
ffuf firefox-esr gftp geany git gnupg gparted gobuster gzip hashcat hexchat htop hydra jq john metasploit-framework \
mitmproxy mupdf net-tools neo4j nikto nmap openssh-server openvpn openjdk-11-jdk os-prober patator powershell \
proxychains4 p7zip python3 rdesktop remmina rkhunter ristretto sqlmap sqlitebrowser smbclient stow stunnel4 \
tcpdump tmux tor thunar telnet tftp tigervnc-viewer tmux thunar-archive-plugin traceroute transmission \
vim virtualbox-guest-utils virtualbox-guest-x11 wfuzz wget wireshark unzip ufw whatweb wget wpscan zaproxy\

# add microsoft repos and install vscode
echo "[*] Adding gpg key for microsoft..."
sleep 2
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update && sudo apt install code

# create folder, download, and extract tool
manualdeploy () {
    echo "[*] Setting up $1 in $tools_dir$1"
    
    if [[ ! -d $tools_dir$1 ]]; then
        mkdir "$tools_dir$1"
    fi
    
    cd $tools_dir$1

    # download package
    echo "[*] Downloading package from: $2"
    wget $2
    IFS="/" 
    read -a package_filename <<< "$2"
    package_filename="${package_filename[-1]}"

    # create directory, determine compression type, and extract
    if [[ -f "$tools_dir$1/$package_filename" ]];then
        echo "[*] Extracting: "$package_filename
        local file_type=$(file -i "$package_filename")
        case "$file_type" in
            *application/x-bzip2*)    
                echo "bzip2 file found"
                tar -xjvf $package_filename
                ;;
            *application/gzip*)
                echo "gzip file found"
                gzip -d $package_filename
                ;;
            *application/zip*)        
                echo "zip file found"
                unzip $package_filename
                ;;
            *application/x-7z-compressed*)       
                echo "7z file found"
                7z x $package_filename
                ;;
            ?)
                echo "${file} cannot be extarcted"
                ;;
        esac
             
    else
        echo "[!] $package_filename not found!"
    fi
    
    IFS=" " 
}

manualdeploy "ghidra" $ghidra_url
manualdeploy "chisel" $chisel_url
manualdeploy "namemash" $namemash_url
manualdeploy "sysinternals" $sysinternals_url
manualdeploy "ngrok" $ngrok_url
manualdeploy "kekeo" $kekeo_url

# set up java correctly. readlink -f $(which java) ?

echo "[*] Commencing nasty number of git clones..."

# Cloud Tools
cloudtools_dir=$tools_dir"Cloud"
if [[ ! -d $cloudtools_dir ]]; then
    mkdir "$cloudtools_dir"
fi
# Cloud Tools
cd "$cloudtools_dir"
git clone https://github.com/Gerenios/AADInternals.git
git clone https://github.com/dafthack/MFASweep.git
git clone https://github.com/NetSPI/MicroBurst.git
git clone https://github.com/dafthack/MSOLSpray.git
git clone https://github.com/hausec/PowerZure.git

# Active Directory
adtools_dir=$tools_dir"ActiveDirectory"
if [[ ! -d $adtools_dir ]]; then
    mkdir "$adtools_dir"
fi
cd "$adtools_dir"
git clone https://github.com/fox-it/aclpwn.py.git
git clone https://github.com/hausec/ADAPE-Script.git
git clone https://github.com/fox-it/BloodHound.py.git
git cloen https://github.com/BloodHoundAD/BloodHound.git
git clone https://github.com/Group3r/Group3r.git
git clone https://github.com/eladshamir/Internal-Monologue.git
git clone https://github.com/fox-it/Invoke-ACLPwn.git
git clone https://github.com/TarlogicSecurity/kerbrute.git
git clone https://github.com/dirkjanm/krbrelayx.git
git clone https://github.com/Dionach/NtdsAudit.git
git clone https://github.com/csababarta/ntdsxtract.git
git clone https://github.com/topotam/PetitPotam.git
git clone https://github.com/HarmJ0y/ASREPRoast.git
git clone https://github.com/ly4k/Certipy.git
git clone https://github.com/micahvandeusen/gMSADumper.git
git clone https://github.com/Kevin-Robertson/Inveigh.git
git clone https://github.com/ropnop/windapsearch.git
git clone https://github.com/HarmJ0y/DAMP.git
git clone https://github.com/Raikia/CredNinja.git
git clone https://github.com/BloodHoundAD/SharpHound.git
git clone https://github.com/kfosaaen/Get-LAPSPasswords.git
git clone https://github.com/benpturner/Invoke-DCOM.git
git clone https://github.com/leoloobeek/LAPSToolkit.git
git clone https://github.com/dafthack/MailSniper.git
git clone https://github.com/Sw4mpf0x/PowerLurk.git
git clone https://github.com/leechristensen/SpoolSample.git
git clone https://github.com/tomcarver16/ADSearch.git
git clone https://github.com/ANSSI-FR/AD-control-paths.git
git clone https://github.com/gdedrouas/Exchange-AD-Privesc.git
git clone https://github.com/GoFetchAD/GoFetch.git
git clone https://github.com/outflanknl/Net-GPPPassword.git
git clone https://github.com/outflanknl/Recon-AD.git
git clone https://github.com/adrecon/ADRecon.git
git clone https://github.com/FuzzySecurity/Sharp-Suite.git

# OSINT
osinttools_dir=$tools_dir"OSINT"
if [[ ! -d $osinttools_dir ]]; then
    mkdir "$osinttools_dir"
fi
cd "$osinttools_dir"
git clone https://github.com/m4ll0k/Infoga.git
git clone https://github.com/vysecurity/LinkedInt.git

# Enumeration
enumtools_dir=$tools_dir"Enumeration"
if [[ ! -d $enumtools_dir ]]; then
    mkdir "$enumtools_dir"
fi
cd "$enumtools_dir"
git clone https://github.com/411Hall/JAWS.git
git clone https://github.com/rasta-mouse/Sherlock.git
git clone https://github.com/rebootuser/LinEnum.git
git clone https://github.com/M4ximuss/Powerless.git
git clone https://github.com/mzet-/linux-exploit-suggester.git
git clone http://github.com/jondonas/linux-exploit-suggester-2.git
git clone https://github.com/SecWiki/linux-kernel-exploits.git
git clone https://github.com/sleventyeleven/linuxprivchecker.git
git clone https://github.com/itm4n/PrivescCheck.git
git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git
git clone https://github.com/GhostPack/Seatbelt.git
git clone https://github.com/AonCyberLabs/Windows-Exploit-Suggester.git
git clone https://github.com/SecWiki/windows-kernel-exploits.git
git clone https://github.com/pentestmonkey/windows-privesc-check.git
git clone https://github.com/bitsadmin/wesng.git
git clone https://github.com/NetSPI/PowerUpSQL.git
git clone https://github.com/tevora-threat/SharpView.git

# Base
cd "$tools_dir"
git clone https://github.com/Tib3rius/AutoRecon.git
git clone https://github.com/AlessandroZ/BeRoot.git
git clone https://github.com/Dionach/CMSmap.git
git clone https://github.com/dnSpy/dnSpy
git clone https://github.com/rbsec/dnscan.git
git clone https://github.com/EmpireProject/Empire.git
git clone https://github.com/SecureAuthCorp/impacket.git
git clone https://github.com/danielbohannon/Invoke-CradleCrafter.git
git clone https://github.com/nettitude/Invoke-PowerThIEf.git
git clone https://github.com/peewpw/Invoke-PSImage.git
git clone https://github.com/Kevin-Robertson/Invoke-TheHash.git
git clone https://github.com/ticarpi/jwt_tool.git
git clone https://github.com/mattrotlevi/lava.git
git clone https://github.com/AlessandroZ/LaZagne.git
git clone https://github.com/curi0usJack/luckystrike.git
git clone https://github.com/gentilkiwi/mimikatz.git
git clone https://github.com/samratashok/nishang.git
git clone https://github.com/quentinhardy/odat.git
git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git
git clone https://github.com/longld/peda.git
git clone https://github.com/besimorhino/powercat.git
git clone https://github.com/Mr-Un1k0d3r/PowerLessShell.git
git clone https://github.com/dirkjanm/PrivExchange.git
git clone https://github.com/DominicBreuker/pspy.git
git clone https://github.com/mattifestation/PSReflect.git
git clone https://github.com/Mr-Un1k0d3r/RedTeamPowershellScripts.git
git clone https://github.com/SpiderLabs/Responder.git
git clone https://github.com/danielmiessler/SecLists.git
git clone https://github.com/Arvanaghi/SessionGopher.git
git clone https://github.com/cobbr/SharpSploit.git
git clone https://github.com/brav0hax/smbexec.git
git clone https://github.com/Veil-Framework/Veil.git
git clone https://github.com/volatilityfoundation/volatility3.git
git clone https://github.com/rasta-mouse/Watson.git
git clone https://github.com/interference-security/kali-windows-binaries.git
git clone https://github.com/FortyNorthSecurity/WMIOps.git
git clone https://github.com/4n4nk3/Wordlister.git
git clone https://github.com/outflanknl/EvilClippy.git
git clone https://github.com/ElevenPaths/FOCA.git
git clone https://github.com/frohoff/ysoserial.git
git clone https://github.com/foxglovesec/RottenPotato.git
git clone https://github.com/breenmachine/RottenPotatoNG.git
git clone https://github.com/ohpe/juicy-potato.git
git clone https://github.com/decoder-it/lonelypotato.git
git clone https://github.com/eladshamir/Internal-Monologue.git
git clone https://github.com/p3nt4/PowerShdll.git
git clone https://github.com/FuzzySecurity/PowerShell-Suite.git
git clone https://github.com/PowerShellMafia/PowerSploit.git
git clone https://github.com/PowerShellEmpire/PowerTools.git
git clone https://github.com/anthemtotheego/SharpExec.git
git clone https://github.com/byt3bl33d3r/SprayingToolkit.git
git clone https://github.com/ZeroPointSecurity/PhishingTemplates.git
git clone https://github.com/GhostPack/Rubeus.git
git clone https://github.com/GhostPack/SafetyKatz.git
git clone https://github.com/GhostPack/SharpUp.git
git clone https://github.com/GhostPack/SharpDPAPI.git
git clone https://github.com/mandiant/SharPersist.git
git clone https://github.com/r3motecontrol/Ghostpack-CompiledBinaries.git
git clone https://github.com/cobbr/Covenant.git
git clone https://github.com/maaaaz/CrackMapExecWin.git
git clone https://github.com/fuzzdb-project/fuzzdb.git
git clone https://github.com/darkoperator/dnsrecon.git
git clone https://github.com/FortyNorthSecurity/Egress-Assess.git
git clone https://github.com/sixstringacks/httpScrape.git
git clone https://github.com/denandz/KeeFarce.git
git clone https://github.com/GhostPack/KeeThief.git
git clone https://github.com/orlyjamie/mimikittenz.git
git clone https://github.com/NytroRST/NetRipper.git
git clone https://github.com/matterpreter/OffensiveCSharp.git
git clone https://github.com/cobbr/PSAmsi.git
git clone https://github.com/gtworek/PSBits.git
git clone https://github.com/cyberark/RiskySPN.git
git clone https://github.com/FSecureLABS/SharpClipHistory.git
git clone https://github.com/vletoux/SpoolerScanner.git
git clone https://github.com/klezVirus/SysWhispers3.git
git clone https://github.com/hfiref0x/UACME.git
git clone https://github.com/praetorian-inc/vulcan.git
git clone https://github.com/BlackArch/webshells.git

##############
## OS Config
##############

# Configure Firewall
echo "[*] Configuring ufw..."
sleep 2
sudo ufw default deny incoming
sudo ufw allow in on lo
sudo ufw allow out from lo
sudo ufw deny in from 127.0.0.0/8
sudo ufw deny in from ::1
echo "y" | sudo ufw enable

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

# Clone setup and dotfiles
echo "[*] Copying os config..."
cd $tools_dir
git clone https://github.com/sixstringacks/os-config.git

# Cleanup for stow
rm ~/.bashrc ~/.bash_profile ~/.profile 
rm -rf ~/.config/Thunar ~/.config/xfce4

# symlink dotfiles
stow -d $tools_dir"os-config/dotfiles" -t ~/ `ls $tools_dir"os-config/dotfiles"`