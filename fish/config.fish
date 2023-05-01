# Always start with tmux
if status is-interactive
and not set -q TMUX
    exec tmux
end

zoxide init fish | source
fish_vi_key_bindings insert
fish_config theme choose "Catppuccin Mocha"

export PATH="$HOME/.cargo/bin:$PATH"
fish_add_path "~/.local/bin/"

set -gx DISPLAY :0
set -gx EDITOR "nvim"
set -gx VISUAL "nvim"

alias lg='lazygit'
alias e='exa'
alias cl='clear'
