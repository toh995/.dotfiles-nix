#####################
# Custom zsh config #
#####################
set -o noclobber
set -o pipefail

# alias ls="ls -1AF --color=auto"
alias ls="eza -1aF"

help() {
  local -r command=$1
  bash <<< "help $command | less"
}

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

# spotify_player
alias spt="spotify_player"

# tmux
alias ta="tmux attach-session -t"
alias tls="tmux ls"
alias tn="tmux new-session -s"

# zoxide
eval "$(zoxide init zsh)"
alias j="z"
#########################
# End custom zsh config #
#########################
