#!/bin/bash

###############################################
# Logging utilities.
#
# Dependencies:
#   colors.sh
###############################################

# Exec guard
[[ "${BASH_SOURCE[0]}" == "$0" ]] && exit 100

##
# Log a message at info level on stderr.
#
# Usage:
#   log_info [message]
##
function log_info {
  local message="$@"
  local source_line="$(caller | awk '{print $1}')"
  local source_file="$(caller | awk '{print $2}' | xargs basename)"
  local color reset
  if stderr_supports_colors; then
    color="$(fmtcode green,bold)"
    reset="$(fmtcode reset)"
  fi
  echo >&2 "$color$source_file:$source_line [INFO] $reset$message"
}

##
# Log a message at warning level on stderr.
#
# Usage:
#   log_warning [message]
##
function log_warning {
  local message="$@"
  local source_line="$(caller | awk '{print $1}')"
  local source_file="$(caller | awk '{print $2}' | xargs basename)"
  local color reset
  if stderr_supports_colors; then
    color="$(fmtcode yellow,bold)"
    reset="$(fmtcode reset)"
  fi
  echo >&2 "$color$source_file:$source_line [WARNING] $reset$message"
}

##
# Log a message at error level on stderr.
#
# Usage:
#   log_error [message]
##
function log_error {
  local message="$@"
  local source_line="$(caller | awk '{print $1}')"
  local source_file="$(caller | awk '{print $2}' | xargs basename)"
  local color reset
  if stderr_supports_colors; then
    color="$(fmtcode red,bold)"
    reset="$(fmtcode reset)"
  fi
  echo >&2 "$color$source_file:$source_line [ERROR] $reset$message"
}

