#!/usr/bin/env bash

BAT=$(echo /sys/class/power_supply/BAT*)
BAT_STATUS="$BAT/status"
BAT_CAP="$BAT/capacity"
#LOW_BAT_PERCENT=25
AC_PROFILE="performance"
BAT_PROFILE="balanced"
# wait a while if needed
[[ -z $STARTUP_WAIT ]] || sleep "$STARTUP_WAIT"

# start the monitor loop
prev=0
while true; do
  # read the current state
  if [[ $(cat "$BAT_STATUS") == "Discharging" ]]; then
    profile=$BAT_PROFILE
  else
    profile=$AC_PROFILE
  fi
  # set the new profile
  if [[ $prev != "$profile" ]]; then
    echo -en "Setting power profile to ${profile}\n"
    powerprofilesctl set $profile
  fi
  prev=$profile
  # wait for the next power change event
  inotifywait -qq "$BAT_STATUS" "$BAT_CAP"
done
