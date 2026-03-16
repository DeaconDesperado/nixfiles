#!/bin/bash

PROCESS_RUNNING=$(pgrep -x "GlobalProtect")

VPN_ESTABLISHED=$(echo "list" | scutil | grep "State:/Network/Service/.*gpd.pan.*/IPv4")

if [ -n "$PROCESS_RUNNING" ] && [ -n "$VPN_ESTABLISHED" ]; then
  sketchybar --set $NAME icon="󰖂" icon.color=0xffa6da95 label="Connected"
else
  sketchybar --set $NAME icon="󰖭" icon.color=0xffed8796 label="Offline"
fi

# 2. Handle the Click (The Fix)
if [ "$SENDER" = "mouse.clicked" ]; then
  sketchybar --set $NAME label="Restarting..."
  
  # 1. Kill any surviving processes
  killall "GlobalProtect" 2>/dev/null
  killall "PanGPA" 2>/dev/null
  
  # 2. Give macOS a moment to acknowledge the teardown
  sleep 2
  
  sketchybar --set $NAME label="Starting..."
  
  # 3. Explicitly tell the GUI agent to start
  # Note: The '-k' flag is crucial—it kicks it into gear
  launchctl kickstart -k gui/$(id -u)/com.paloaltonetworks.gp.pangpa
  
  # 4. Optional: If the above fails, use 'open' as a fallback
  if ! pgrep -x "GlobalProtect" > /dev/null; then
    open -a "/Applications/GlobalProtect.app"
  fi

  sleep 2
  sketchybar --trigger vpn_update
fi
