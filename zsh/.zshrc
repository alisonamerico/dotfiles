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

# Show info better
alias ll='eza -la --icons'

# Yazi file manager (shortcut "y")
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Zoxide (A smarter cd command for your terminal)
eval "$(zoxide init zsh)"
