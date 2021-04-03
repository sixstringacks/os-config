# configure user, install sudo vim, add to sudo group

# install bspwm
sudo apt install xorg bspwm xterm feh compton polybar rofi lxappearance libnotify-bin dunst breeze-cursor-theme -y

sudo pip3 install pywal

# Clone setup and dotfiles
git clone https://github.com/autocowrekt/os-config.git

# Cleanup for stow
rm ~/.bashrc ~/.bash_profile

# symlink dotfiles
dotfiles=`ls ~/os-config/dotfiles`
stow -d ~/os-config/wallpaper/dotfiles -t ~/ $dotfiles

# Make files executable
chmod 750 ~/.config/bspwm/bspwmrc
chmod 750 ~/.config/sxhkd/sxhkdrc
chmod 750 ~/.config/polybar/launch.sh
chmod 750 ~/.config/dunst/dunstrc