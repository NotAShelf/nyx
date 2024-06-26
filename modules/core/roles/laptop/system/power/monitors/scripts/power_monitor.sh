#!/usr/bin/env bash

BAT=$(echo /sys/class/power_supply/BAT*)
BAT_STATUS="$BAT/status"
BAT_CAP="$BAT/capacity"
AC_PROFILE="performance"
BAT_PROFILE="balanced"

# low and critical battery levels
LOW_BAT_PERCENT=25
CRIT_BAT_PERCENT=5

# how long to wait before suspending
SUSPEND_WAIT=60s

# define the wait & suspend function
wait_and_suspend() {
  sleep "$SUSPEND_WAIT"

  # check if we're still discharging
  if [[ $(cat "$BAT_STATUS") == "Discharging" ]]; then
    systemctl suspend
  fi
}

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

  if [[ $(cat "$BAT_CAP") -le $LOW_BAT_PERCENT && $BAT_STATUS == "Discharging" ]]; then
    notify-send --urgency=critical --hint=int:transient:1 --icon=battery_empty "Battery Low" \
      "Consider plugging in."

    for i in $(hyprctl instances -j | jaq ".[].instance" -r); do
      hyprctl -i "$i" --batch 'keyword decoration:blur:enabled false; keyword animations:enabled false'
    done
  fi

  if [[ $(cat "$BAT_CAP") -le $CRIT_BAT_PERCENT && $BAT_STATUS == "Discharging" ]]; then
    notify-send --urgency=critical --hint=int:transient:1 --icon=battery_empty "Battery Critically Low" \
      "Computer will suspend in 60 seconds."
    wait_and_suspend &
  fi

  if [[ $(cat "$BAT_CAP") -gt $LOW_BAT_PERCENT && $BAT_STATUS == "Charging" ]]; then
    for i in $(hyprctl instances -j | jaq ".[].instance" -r); do
      hyprctl -i "$i" --batch 'keyword decoration:blur:enabled true; keyword animations:enabled true'
    done
  fi

  # wait for the next power change event
  inotifywait -qq "$BAT_STATUS" "$BAT_CAP"
done
