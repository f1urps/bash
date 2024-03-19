#!/bin/bash

###############################################
# Dynamic bash prompt.
###############################################

# Exec guard
[[ "${BASH_SOURCE[0]}" == "$0" ]] && exit 100

##
# Commands to toggle the PROMPT_PATH_STYLE setting,
# which controls how the current path is displayed in the prompt.
#
#   none:  Only the basename of $PWD is displayed, with no path.
#   full:  Full path is displayed (relative to ~ or workspace root)
#   short: Full path is displayed, but directory names are shortened to one character.
##
alias pps_none="export PROMPT_PATH_STYLE=none"
alias pps_full="export PROMPT_PATH_STYLE=full"
alias pps_short="export PROMPT_PATH_STYLE=short"

##
# Call this from .bashrc to set the prompt.
#
# Example:
#   set_prompt \
#     enable_color=yes \
#     prefix=rainbow,cloud,hostname \
#     path=full
#
# `prefix` controls what elements are placed before the workspace name and path.
#  Available prefix elements: rainbow, wobniar, cloud, hostname
#  Elements can be in any order, for example:
#   cloud,rainbow
#   rainbow,cloud
#   cloud,cloud,hostname,cloud,cloud
#
# `path` controls how the current path is displayed in the prompt.
#   none:  Only the basename of $PWD is displayed, with no path.
#   full:  Full path is displayed (relative to ~ or workspace root)
#   short: Full path is displayed, but directory names are shortened to one character.
##
function set_prompt {
  local enable_color="$(eval "$@"; echo $enable_color)"
  local prefix="$(eval "$@"; echo $prefix)"
  local path="$(eval "$@"; echo $path)"
  local main_color="$(eval "$@"; echo $main_color)"

  local main_color_code="\[\e[${main_color}m\]"
  local main_color_code_bold="\[\e[1;${main_color}m\]"
  local trans='\[\e[104m\] \[\e[105m\] \[\e[47m\] \[\e[105m\] \[\e[104m\] '
  local rainbow='\[\e[31;41m\] \[\e[m\]\[\e[33;43m\] \[\e[m\]\[\e[32;42m\] \[\e[m\]\[\e[36;46m\] \[\e[m\]\[\e[34;44m\] \[\e[m\]'
  local wobniar='\[\e[34;44m\] \[\e[m\]\[\e[36;46m\] \[\e[m\]\[\e[32;42m\] \[\e[m\]\[\e[33;43m\] \[\e[m\]\[\e[31;41m\] \[\e[m\]'
  local cloud="$main_color_code☁ \[\e[m\]"
  local heart="$main_color_code\e[95m\]❤\[\e[m\]"
  local hostname="$main_color_code_bold\H \[\e[m\]"
  local user="$main_color_code_bold\u \[\e[m\]"
  local root="$main_color_code_bold\e[31m\][ROOT] \[\e[m\]"

  local prefix_list=$(echo "$prefix" | tr "," "\n")
  local prefixstr
  local s
  for s in $prefix_list; do
    case "$s" in
      "trans")
        prefixstr="$prefixstr$trans";;
      "rainbow")
        prefixstr="$prefixstr$rainbow";;
      "wobniar")
        prefixstr="$prefixstr$wobniar";;
      "cloud")
        prefixstr="$prefixstr$cloud";;
      "heart")
        prefixstr="$prefixstr$heart";;
      "hostname")
        prefixstr="$prefixstr$hostname";;
      "user")
        prefixstr="$prefixstr$user";;
      "root")
        prefixstr="$prefixstr$root";;
    esac
  done

  export PROMPT_PATH_STYLE="$path"

  if [[ "$enable_color" == "true" || "$enable_color" == "yes" ]]; then
    PS1="$prefixstr\[\e[0;36m\] \$(_prompt_dirname)\[\e[1;36m\]\$(_prompt_basename)\[\e[m\]\$ "
  else
    PS1="\$(_prompt_dirname)\$(_prompt_basename)\$"
  fi
}

# Dirname of current directory, formatted for use in the prompt.
# This function is called every time the prompt is rendered.
function _prompt_dirname {
  local d="$(dirs)"
  local dirname
  if [[ "$PROMPT_PATH_STYLE" = "none" ]]; then
    return
  elif [[ "$PROMPT_PATH_STYLE" = "short" ]]; then
    d=$(echo "/$d" | sed -r 's|/(.)[^/]*|/\1|g')
    d="${d:1}"
  fi
  dirname="$(dirname "$d")"
  if [ -n "$d" ]; then
    if ! [[ "$dirname" = "." || "$d" = "/" || "$d" = "~" ]]; then
      if [[ "$dirname" = "/" ]]; then
        echo "$dirname"
      else
        echo "$dirname/"
      fi
    fi
  fi
}

# Basename of the current directory, formatted for use in the prompt.
# This function is called every time the prompt is rendered.
function _prompt_basename {
  local d="$(dirs)"
  local basename="$(basename "$d")"
  if [ -n "$d" ]; then
    if ! [ "$basename" = "." ]; then
      echo "$basename"
    fi
  fi
}

