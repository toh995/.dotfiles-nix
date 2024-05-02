#####################
# Custom zsh config #
#####################
set -o noclobber
set -o pipefail

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# alias ls="ls -1AF --color=auto"
alias ls="eza -1aF"

help() {
  local -r command=$1
  bash <<< "help $command | less"
}

# go
export GOPATH="${XDG_DATA_HOME}/go"
export GOMODCACHE="${XDG_CACHE_HOME}/go/mod"
export PATH="${GOPATH}/bin:${PATH}"

# lazydocker
alias ld="lazydocker"

# lazygit
alias lg="lazygit"

# less
export LESS="${LESS} -R --mouse"
# set colors, i.e. for man pages
autoload -U colors && colors
export LESS_TERMCAP_mb="${fg_bold[red]}"
export LESS_TERMCAP_md="${fg_bold[red]}"
export LESS_TERMCAP_me="${reset_color}"
export LESS_TERMCAP_so="${bg_bold[yellow]}${fg_bold[black]}"
export LESS_TERMCAP_se="${reset_color}"
export LESS_TERMCAP_us="${fg_bold[green]}"
export LESS_TERMCAP_ue="${reset_color}"
export GROFF_NO_SGR=1

# neovim
alias n="nvim ."

# nnn
export NNN_OPTS="H"

# node
export NODE_REPL_HISTORY="$XDG_STATE_HOME"/nodejs/.node_repl_history
[[ -f "${NODE_REPL_HISTORY}" ]] || \
  mkdir -p "$( dirname "${NODE_REPL_HISTORY}" )"

# spotify_player
alias spt="spotify_player"

# tmux
ta() {
	local -r session_name="${1}"
  if [[ -z "${session_name}" ]]; then
    tmux attach-session
  else
    tmux attach-session -t "${session_name}"
  fi
}
alias tls="tmux ls"
alias tn="tmux new-session -s"

# zoxide
eval "$(zoxide init zsh)"
alias j="z"

# zsh vi-mode
export ZVM_VI_INSERT_ESCAPE_BINDKEY=kj
#########################
# End custom zsh config #
#########################
