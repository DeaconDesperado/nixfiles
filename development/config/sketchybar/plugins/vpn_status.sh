#!/bin/bash

# 1. Check if the VPN route exists (Dynamic Check)
VPN_ACTIVE=$(netstat -nr -f inet | grep "utun" | awk '{print $4}' | grep -v "lo0" | head -n 1)

if [ -n "$VPN_ACTIVE" ]; then
  sketchybar --set $NAME icon="󰖂" icon.color=0xffa6da95 label="Connected"
else
  sketchybar --set $NAME icon="󰖭" icon.color=0xffed8796 label="Offline"
fi

# 2. Handle the Click (The Fix)
if [ "$SENDER" = "mouse.clicked" ]; then
  sketchybar --set $NAME label="Restarting..."
  
  # Kill the GUI app; macOS 'launchd' will restart it automatically
  killall "GlobalProtect" 2>/dev/null
  
  # Give it a second to respawn
  sleep 2
  sketchybar --trigger vpn_update
fi
