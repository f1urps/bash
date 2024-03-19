#!/bin/bash

###############################################
# Simple bash aliases.
###############################################

# Exec guard
[[ "${BASH_SOURCE[0]}" == "$0" ]] && exit 100

# Overrides of well-known programs
alias vim=nvim
alias ls='exa --color=auto'
alias df='df -h'
alias grep='grep --color=auto'
alias diff='diff --color=auto'

# Alias exa if not available
if ! type exa 2>/dev/null 1>&2; then
  alias exa=eza
fi

# Reload the terminal
alias rl="source $HOME/.bashrc"

# Reload tmux
alias rlt="tmx2 source-file $HOME/.tmux.conf"

# Open todo notes
alias todo='vim ~/notes/todo'

# Manage dotfiles
alias git-dotfiles='git --git-dir=$HOME/.git-dotfiles --work-tree=$HOME'

# Wait for confirmation, then run a command
function wait {
  cmd="$@"
  read -p "[press enter to run '$cmd']" && eval "$cmd"
}

