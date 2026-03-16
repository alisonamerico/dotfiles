# Hyprland Setup

Automatic setup script for Hyprland on Arch Linux.

## Prerequisites

1. Arch Linux installed
2. Internet connection
3. User with sudo privileges

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/alisonamerico/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Give execute permission to the script

```bash
chmod +x scripts/setup-hyprland.sh
```

### 3. Run the script

```bash
./scripts/setup-hyprland.sh
```

The script will prompt you to choose:
- CPU (Intel/AMD)
- Video driver (Nvidia/AMD/Intel)
- Which packages to install
- Which dotfiles to apply with stow

## Post-installation

### Apply configurations with Stow

After installation, to apply the configurations:

```bash
cd ~/dotfiles

# Check available packages
ls -d */

# Apply all at once
stow -t $HOME hypr waybar rofi zsh kitty nvim tmux git yazi ruff wallpaper

# Or apply individually
stow -t $HOME hypr
stow -t $HOME waybar
stow -t $HOME rofi
stow -t $HOME zsh
stow -t $HOME kitty
stow -t $HOME nvim
stow -t $HOME tmux
stow -t $HOME git
stow -t $HOME yazi
stow -t $HOME ruff
stow -t $HOME wallpaper
```

### Reload configurations

- **Hyprland**: `Super + Ctrl + R` (reloads Hyprland + Waybar)
- **Waybar only**: `Super + Ctrl + Shift + R`

## Hyprland Shortcuts

| Shortcut | Action |
|----------|--------|
| `Super + R` | Open menu (rofi) |
| `Super + B` | Open Brave |
| `Super + N` | Open Neovim |
| `Super + Q` | Close window |
| `Super + J/K/H/L` | Move focus |
| `Super + Shift + J/K/H/L` | Move window |
| `Super + 1-0` | Workspaces |
| `Print` | Screenshot (selection) |
| `Super + =/-` | Volume +/- |
| `Super + M` | Mute |
| `Super + ,/.` | Brightness +/- |

## Dotfiles Structure

```
dotfiles/
├── hypr/.config/hypr/      # Hyprland config
├── waybar/.config/waybar/  # Waybar config
├── rofi/.config/rofi/      # Rofi themes
├── zsh/.zshrc             # Zsh config
├── kitty/.config/kitty/   # Kitty terminal
├── nvim/.config/nvim/     # Neovim config
├── tmux/.tmux.conf       # Tmux config
├── git/.gitconfig         # Git config
├── yazi/                  # Yazi config
├── ruff/ruff.toml         # Ruff config
├── wallpaper/             # Wallpapers
└── scripts/              # Setup scripts
```

## Installed Packages

### Official repository (pacman)
- hyprland, hypridle, hyprlock, xdg-desktop-portal-hyprland
- waybar, rofi, dunst, sddm
- brightnessctl, pavucontrol
- networkmanager, network-manager-applet
- blueman, bluez, bluez-utils
- git, kitty, tmux, zsh
- firefox, mpv, fastfetch
- eza, zoxide, yazi, stow
- grim, slurp, wl-clipboard, playerctl, swww, satty
- noto-fonts-emoji, papirus-icon-theme
- tree, wget, unzip, fd
- nodejs, npm, docker, docker-compose
- Video drivers: nvidia/nvidia-open/amd/intel + mesa

### AUR (yay)
- brave-bin
- neovim-nightly-bin

## Fonts

### Nerd Fonts
- JetBrainsMono, FiraCode, Hack, Ubuntu

### System Fonts
- Noto (Sans, Serif, Mono)

## Troubleshooting

### Waybar doesn't appear
```bash
killall waybar
waybar &
```

### Config doesn't load
```bash
hyprctl reload
```

### Audio doesn't work
Check if PipeWire is running:
```bash
systemctl --user status pipewire
```

### Bluetooth doesn't work
```bash
blueman-manager
```

## Author

Alison
