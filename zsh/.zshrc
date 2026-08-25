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

# Eza - Show info better
alias ll='eza -la --icons'
alias ls='eza --icons --grid --group-directories-first --git -a'
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

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

# Added by uv
# curl -LsSf https://astral.sh/uv/install.sh | sh# Added by uv
. "$HOME/.local/share/../bin/env"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

# NPM global bin (added by Qwen Code installer)
export PATH="$HOME/.npm-global/bin:$PATH"

# `inspect-5p` is a shell function that must be defined in your `~/.bashrc` (or `~/.zshrc`).
# It captures all uncommitted changes and sends them to `opencode run` for a structured
# 5-dimension review.
inspect-5p() {
  local diff
  diff=$(git diff --staged; git diff)

  if [ -z "$diff" ]; then
    echo "No uncommitted changes to review."
    return 1
  fi

  opencode run "Review these changes across 5 dimensions:
1. Security — any vulnerabilities or sensitive data exposure?
2. Correctness — logic errors, edge cases, wrong behavior?
3. Design — violates project conventions or architecture?
4. Testing — missing tests or weak assertions?
5. Conventions — style, naming, commit message quality?

List issues found per dimension. Be direct and specific.

Changes to review:
$diff"
}


# Added by Antigravity CLI installer
export PATH="/home/alison/.local/bin:$PATH"
