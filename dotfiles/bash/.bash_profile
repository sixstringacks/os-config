#!/bin/bash

# Automatically start xorg
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec startx; fi

# Source bashrc
source ~/.bashrc
