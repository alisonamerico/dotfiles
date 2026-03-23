# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Required for the minimal theme to update colors dynamically
setopt prompt_subst

# Force minimal theme precmd to override any existing precmd functions
precmd_functions=()

# Theme selection
# https://github.com/subnixr/minimal
ZSH_THEME="minimal"

# Oh My Zsh plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Add Neovim installed via Bob to PATH
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="$HOME/.local/share/bob/env:$PATH"

# Set Neovim as default editor
export EDITOR="nvim"
export VISUAL="nvim"

# Shortcut to open Neovim
alias v="nvim"

# Clear terminal
alias c="clear"

# Brave without wallet
alias brave="brave --disable-brave-wallet --disable-ethereum"

# Show info better
alias ll='eza -la --icons'
alias ls='eza --icons --grid --group-directories-first'

# Yazi file manager (shortcut "y")
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

#compdef jiratui

_jiratui_completion() {
    local -a completions
    local -a completions_with_descriptions
    local -a response
    (( ! $+commands )) && return 1

    response=("${(@f)$(env COMP_WORDS="${words[*]}" COMP_CWORD=$((CURRENT-1))
_JIRATUI_COMPLETE=zsh_complete jiratui)}")

    for type key descr in ${response}; do
        if [[ "$type" == "plain" ]]; then
            if [[ "$descr" == "_" ]]; then
                completions+=("$key")
            else
                completions_with_descriptions+=("$key":"$descr")
            fi
        elif [[ "$type" == "dir" ]]; then
            _path_files -/
        elif [[ "$type" == "file" ]]; then
            _path_files -f
        fi
    done

    if [ -n "$completions_with_descriptions" ]; then
        _describe -V unsorted completions_with_descriptions -U
    fi

    if [ -n "$completions" ]; then
        compadd -U -V unsorted -a completions
    fi
}

if [[ $zsh_eval_context[-1] == loadautofunc ]]; then
    # autoload from fpath, call function directly
    _jiratui_completion "$@"
else
    # eval/source/. command, register function for later
    compdef _jiratui_completion jiratui
fi

# Zoxide (A smarter cd command for your terminal)
eval "$(zoxide init zsh)"

# Added by uv
# curl -LsSf https://astral.sh/uv/install.sh | sh# Added by uv
. "$HOME/.local/share/../bin/env"
