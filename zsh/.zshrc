# Startship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Poetry
# export PATH="$HOME/.local/bin:$PATH"

# Yazi
export EDITOR="nvim"
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Clear
alias cl='clear'

# Neovim
alias v='nvim'

# pocket plan
alias pp='~/dotfiles/pocket_plan_score.sh'

slugify() {
  echo "$@" | tr '[:upper:]' '[:lower:]' | tr '[ ]' '-' | tr -dc '[:alnum:]-' | sed 's/[-]*$//g'
}

# slugify text
alias slg='slugify'
# alias slg='~/dotfiles/slugify.sh'

# conventional commits
alias concs='~/dotfiles/conventional_commits.sh'

# History setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
source /home/$USER/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /home/$USER/dotfiles/slugify.sh

# export ELECTRON_OZONE_PLATFORM_HINT "wayland"
export ELECTRON_ENABLE_OZONE=1
export OZONE_PLATFORM=wayland

 export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


