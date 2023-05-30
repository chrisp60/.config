export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export PATH="/home/chris/.local/share/fnm:$PATH" # fnm
. "$HOME/.cargo/env"

ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode auto  
zstyle ':omz:update' frequency 13

# DISABLE_LS_COLORS="true"
DISABLE_AUTO_TITLE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# oh-my-zsh plugin settings
ZSH_TMUX_AUTOSTART=false

# vim zsh plugin likes their config in this function
function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}

plugins=(zsh-vi-mode tmux)
source $ZSH/oh-my-zsh.sh

eval "`fnm env`" #fnm
eval "$(zoxide init zsh)"

alias lg="lazygit"
alias tn="tmux new-session\; split-window -h -p 35\; select-pane -t 0"

