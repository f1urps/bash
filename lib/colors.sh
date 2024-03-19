#!/bin/bash

###############################################
# Color utilities.
###############################################

# Exec guard
[[ "${BASH_SOURCE[0]}" == "$0" ]] && exit 100

##
# Check if stdout supports color output.
#
# Returns success if colors are supported.
# Returns failure otherwise.
##
function stdout_supports_colors {
  test -t 1 && terminal_supports_colors
}

##
# Check if stderr supports color output.
#
# Returns success if colors are supported.
# Returns failure otherwise.
##
function stderr_supports_colors {
  test -t 2 && terminal_supports_colors
}

##
# Check if the current terminal session supports color output.
#
# Returns success if colors are supported.
# Returns failure otherwise.
##
function terminal_supports_colors {
  test -n "$(tput colors)" && test "$(tput colors)" -ge 8
}

##
# Output the formatting code for a given color or style.
#
# Argument can be a single color/style name, or multiple
# name separated by commas.
#
# Usage:
#   fmtcode [style1,style2,...]
#
# Example:
#   fmtcode green
#   fmtcode red,bold,underline
##
function fmtcode {
  local styles="$1"
  local color_is_light
  local style_list
  local style_name
  local result
  local n

  style_list=$(echo "$styles" | tr "," "\n")
  for style_name in $style_list; do

    # Handle non-color styles
    case "$style_name" in
      reset)              result+="$(tput sgr0)";;
      bold)               result+="$(tput bold)";;
      underline)          result+="$(tput smul)";;

      # Foreground colors
      black)              result+="$(tput setaf 0)";;
      red)                result+="$(tput setaf 1)";;
      green)              result+="$(tput setaf 2)";;
      yellow)             result+="$(tput setaf 3)";;
      blue)               result+="$(tput setaf 4)";;
      magenta)            result+="$(tput setaf 5)";;
      cyan)               result+="$(tput setaf 6)";;
      white)              result+="$(tput setaf 7)";;
      lblack)             result+="$(tput setaf 8)";;
      lred)               result+="$(tput setaf 9)";;
      lgreen)             result+="$(tput setaf 10)";;
      lyellow)            result+="$(tput setaf 11)";;
      lblue)              result+="$(tput setaf 12)";;
      lmagenta)           result+="$(tput setaf 13)";;
      lcyan)              result+="$(tput setaf 14)";;
      lwhite)             result+="$(tput setaf 15)";;

      # Background colors
      black_bg)           result+="$(tput setab 0)";;
      red_bg)             result+="$(tput setab 1)";;
      green_bg)           result+="$(tput setab 2)";;
      yellow_bg)          result+="$(tput setab 3)";;
      blue_bg)            result+="$(tput setab 4)";;
      magenta_bg)         result+="$(tput setab 5)";;
      cyan_bg)            result+="$(tput setab 6)";;
      white_bg)           result+="$(tput setab 7)";;
      lblack_bg)          result+="$(tput setab 8)";;
      lred_bg)            result+="$(tput setab 9)";;
      lgreen_bg)          result+="$(tput setab 10)";;
      lyellow_bg)         result+="$(tput setab 11)";;
      lblue_bg)           result+="$(tput setab 12)";;
      lmagenta_bg)        result+="$(tput setab 13)";;
      lcyan_bg)           result+="$(tput setab 14)";;
      lwhite_bg)          result+="$(tput setab 15)";;

      *)
        # Handle color codes 16-255 (fg)
        if [[ "$style_name" =~ ^([0-9]+)$ ]]; then
          n="${BASH_REMATCH[1]}"
          if [[ "$n" -ge 0 && "$n" -lt "$(tput colors)" ]]; then
            result+="$(tput setaf "$n")"
          else
            echo >&2 "Error: Color code out of range: '$n'"
            return 2
          fi

        # Handle color codes 16-255 (bg)
        elif [[ "$style_name" =~ ^([0-9]+)_bg$ ]]; then
          n="${BASH_REMATCH[1]}"
          if [[ "$n" -ge 0 && "$n" -lt "$(tput colors)" ]]; then
            result+="$(tput setab "$n")"
          else
            echo >&2 "Error: Color code out of range: '$n'"
            return 3
          fi

        else
          echo >&2 "Error: Unknown style: '$style_name'"
          return 4
        fi
        ;;

    esac
  done

  echo -n "$result"
}

##
# Output a grid of all colors supported in the terminal,
# either as foreground or background colors. (fg by default)
#
# Usage:
#   colorgrid [fg|bg]
##
function colorgrid {
  local type="$1"
  local i=0
  local cells_in_this_line=0
  local cells_per_line=16
  local total_colors="$(tput colors)"
  local cell_str

  while [[ "$i" -lt "$total_colors" ]]; do
    case "$(expr length $i)" in
      1) cell_str="  $i";;
      2) cell_str=" $i";;
      3) cell_str="$i";;
    esac
    case "$type" in
      bg) tput setab "$i"; tput setaf "$i"; tput bold;;
      fg|*)  tput setaf "$i"; tput bold;
    esac
    echo -n "$cell_str "; tput sgr0
    (( cells_in_this_line++ ))
    (( i++ ))
    if [[ "$cells_in_this_line" -ge "$cells_per_line" ]]; then
      echo
      cells_in_this_line=0
    fi
  done
}

##
# Output every combination of foreground
# and background colors for the 16 basic colors.
##
function colorgrid_basic_combos {
  local i
  local j
  local k
  local s
  local n
  let k=0
  while [[ $k -lt 16 ]]; do
    n=$k
    if [[ $(expr length $n) = 1 ]]; then
      n=" $n"
    fi
    s="$s\$(tput setaf $k)$n"
    let k=k+1
  done
  eval "echo \"$s\""
  let i=0
  while [[ $i -lt 16 ]]; do
    n=$i
    if [[ $(expr length $n) = 1 ]]; then
      n=" $n"
    fi
    s="\$(tput setab 0)\$(tput setaf $i)$n"
    let j=1
    while [[ $j -lt 16 ]]; do
      s="$s\$(tput setab $j)$n"
      let j=j+1
    done
    s="$s\$(tput setab 0)"
    eval "echo \"$s\""
    let i=i+1
  done
}

