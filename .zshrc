export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 13

# DISABLE_LS_COLORS="true"
DISABLE_AUTO_TITLE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
ENABLE_CORRECTION="true"

# oh-my-zsh plugin settings
ZSH_TMUX_AUTOSTART=true

# vim zsh plugin likes their config in this function
function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}

plugins=(git zsh-vi-mode tmux)
source $ZSH/oh-my-zsh.sh

alias lg="lazygit"

export PATH="/home/chris/.local/share/fnm:$PATH" # fnm
eval "`fnm env`" #fnm
eval "$(zoxide init zsh)"

