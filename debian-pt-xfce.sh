# Install xfce
sudo apt install xfce4-desktop ligthdm

# Remove Unneeded Software
sudo apt purge at aspell aspell-en avahi-daemon bc dc debian-faq dictionaries-common doc-debian eject fdutils mousepad xfburn xsane* hv3 exfalso quodlibet parole eject gstreamer1.0-alsa gstreamer1.0-plugins-base gstreamer1.0-gl    gstreamer1.0-plugins-good gstreamer1.0-gtk3 gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-pulseaudio gstreamer1.0-plugins-bad   gstreamer1.0-x hddtemp laptop-detect lm-sensors mobile-broadband-provider-info pavucontrol speech-dispatcher system-config-printer system-config-printer-common system-config-printer-udev alsa-topology-conf alsa-utils alsa-ucm-conf aspell atril cups-client cups-common cups-pk-helper hunspell-en-us iamerican ibritish ienglish-common mythes-en-us modemmanager ppp pulseaudio* sound-theme-freedesktop  fdutils iamerican ibritish ispell laptop-detect mutt nano ppp reportbug usbutils wamerican whiptail  && sudo apt autoclean && sudo apt autoremove

# Themes, etc
sudo apt install arc-theme elementary-xfce-icon-theme numix-* adapta-gtk-theme blackbird-gtk-theme bluebird-gtk-theme deepin-icon-theme adwaita-icon-theme ttf-anonymous-pro