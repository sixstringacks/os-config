sudo apt install i3

# i3 configuration
cp ~/.config/i3/config ~/.config/i3/config.bak
cat <<EOF | tee ~/.config/i3/config
# i3 config file (v4)

## Mod Key
# set $mod Mod4 # Super
set $mod Mod1 # Alt


font pango:monospace 6

## Startup
# exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork
exec --no-startup-id nm-applet

## Audio (not needed for VM)
#set $refresh_i3status killall -SIGUSR1 i3status
#bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
#bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
#bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
#bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# start a terminal
bindsym $mod+Return exec i3-sensible-terminal

# kill focused window
bindsym $mod+Shift+q kill

# change focus
bindsym $mod+j focus left
bindsym $mod+k focus down
bindsym $mod+l focus up
bindsym $mod+semicolon focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+j move left
bindsym $mod+Shift+k move down
bindsym $mod+Shift+l move up
bindsym $mod+Shift+semicolon move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+h split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child

# Define names for default workspaces for which we configure key bindings later on.
# We use variables to avoid repeating the names in multiple places.
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

# switch to workspace
bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4
bindsym $mod+5 workspace number $ws5
bindsym $mod+6 workspace number $ws6
bindsym $mod+7 workspace number $ws7
bindsym $mod+8 workspace number $ws8
bindsym $mod+9 workspace number $ws9
bindsym $mod+0 workspace number $ws10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4
bindsym $mod+Shift+5 move container to workspace number $ws5
bindsym $mod+Shift+6 move container to workspace number $ws6
bindsym $mod+Shift+7 move container to workspace number $ws7
bindsym $mod+Shift+8 move container to workspace number $ws8
bindsym $mod+Shift+9 move container to workspace number $ws9
bindsym $mod+Shift+0 move container to workspace number $ws10

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym j resize shrink width 10 px or 10 ppt
        bindsym k resize grow height 10 px or 10 ppt
        bindsym l resize shrink height 10 px or 10 ppt
        bindsym semicolon resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape or $mod+r
        bindsym Return mode "default"
        bindsym Escape mode "default"
        bindsym $mod+r mode "default"
}

bindsym $mod+r mode "resize"

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)

# Startup
exec --no-startup-id vmware-user-suid-wrapper
exec --no-startup-id xrandr -s 1400x1050

# Theme
# class                 border  bground text    indicator child_border
client.focused          #5E5E5E #3D3D3D #FFFFFF #2E9EF4   #C8C8C8
client.focused_inactive #333333 #5F676A #FFFFFF #484E50   #5F676A
client.unfocused        #333333 #222222 #888888 #292D2E   #222222
client.urgent           #2F343A #900000 #FFFFFF #900000   #900000
client.placeholder      #000000 #0C0C0C #FFFFFF #000000   #0C0C0C

client.background       #FFFFFF

bar {
  status_command i3status
  position top

  colors {
    background #242424
    statusline #FFFFFF
    separator  #666666

    focused_workspace  #4C7899 #285577 #FFFFFF
    active_workspace   #333333 #222222 #FFFFFF
    inactive_workspace #333333 #222222 #888888
    urgent_workspace   #2F343A #900000 #FFFFFF
    binding_mode       #2F343A #900000 #FFFFFF
  }
}

bindsym $mod+d exec "dmenu_run -nf '#BBBBBB' -nb '#222222' -sb '#005577' -sf '#EEEEEE' -fn 'monospace-10' -p 'dmenu prompt'"
EOF

echo -e "[*] Configuring /etc/i3status.conf"
sudo cp /etc/i3status.conf /etc/i3status.conf_old
cat <<EOF | tee /etc/i3status.conf
general {
    interval 		= 1
    colors 			= true
    color_good      = '#88b090'
    color_degraded  = '#ccdc90'
    color_bad       = '#e8c4af'
}

order += "run_watch VPN"
order += "ethernet _first_"
order += "disk /"
order += "cpu_usage 0"
order += "load"
order += "memory"
order += "tztime local"

run_watch VPN {
    pidfile = "/var/run/vpnc/pid"
}

ethernet _first_ {
	format_up = "E: %ip (%speed)"
	format_down = "E: down"
}

disk "/" {
	format = "%avail"
	prefix_type	= custom
	low_threshold = 20
	threshold_type = percentage_avail
}

cpu_usage {
    format = "%usage"
}

load {
    format = "%5min"
}

memory {
	format = "%used | %available"
	threshold_degraded = "15%"
	format_degraded = "MEMORY < %available"
}

tztime local {
    format = "%Y.%m.%d %H:%M:%S"
}
EOF