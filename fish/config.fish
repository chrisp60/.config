# Always start with tmux
if status is-interactive
and not set -q TMUX
    exec tmux
end

zoxide init fish | source
fish_vi_key_bindings insert
fish_config theme choose "Catppuccin Mocha"

export PATH="$HOME/.cargo/bin:$PATH"
set -gx DISPLAY :0

alias lg='lazygit'
alias sc='source'
alias cl='clear'
alias lsa='ls -al'

