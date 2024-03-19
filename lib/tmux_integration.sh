#!/bin/bash

###############################################
# Tmux integrations.
###############################################

# Exec guard
[[ "${BASH_SOURCE[0]}" == "$0" ]] && exit 100

##
# Get the name of the current tmux window.
# Outputs nothing if not currently in a tmux session.
#
# Usage:
#   tmux_window
##
function tmux_window {
  if [[ ! -z "$TMUX" ]]; then
    tmx2 display-message -p '#W'
  fi
}

