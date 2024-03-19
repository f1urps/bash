#!/bin/bash

###############################################
# Randomness.
###############################################

# Exec guard
[[ "${BASH_SOURCE[0]}" == "$0" ]] && exit 100

##
# Select one of the arguments randomly and run it as
# a command in the current shell.
#
# Usage:
#   random_select_eval [commands...]
##
function random_select_eval {
  eval "$(random_select "$@")"
}

##
# Select one of the arguments randomly and return it.
#
# Usage:
#   random_select [values...]
##
function random_select {
  local index="$(random_int $# 1)"
  echo "${!index}"
}

##
# Generate a random integer within a range.
# If range_start is omitted, the range starts at zero.
#
# Usage:
#   random_int [range_len] (range_start)
##
function random_int {
  local range_len="$1"
  local range_start="$2"
  [[ -z "$range_start" ]] && range_start=0
  echo "$(( $range_start + $RANDOM % $range_len ))"
}

