#!/bin/bash

###############################################
# Device controls.
###############################################

# Exec guard
[[ "${BASH_SOURCE[0]}" == "$0" ]] && exit 100

# Turn off bluetooth
alias btoff='bluetoothctl power off'

# Turn on bluetooth and connect to my headphones
function bt {
  bluetoothctl power on
  while ! bluetoothctl connect 00:16:94:3A:AD:81; do
    echo 'Retrying in 1 second...'; sleep 1
  done
}

# Brightness controls
alias brightness_max='brightnessctl -q s "$(brightnessctl m)"'
alias brightness_half='brightnessctl -q s "$(($(brightnessctl m) / 2))"'

# Get list of wifi networks
alias wifi='nmcli d wifi list'

# Connect to wifi
# wifi_connect [SSID] [password]
function wifi_connect {
  nmcli d wifi connect "$1" password "$2"
}

