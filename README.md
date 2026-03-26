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

```bash
cd ~/dotfiles

# Check available packages
ls -d */

# Apply packages (excluding sddm which needs sudo)
stow -t $HOME hypr waybar rofi zsh kitty nvim tmux git yazi ruff dunst images scripts

# SDDM theme (requires sudo)
sudo ./sddm/install-sddm-theme.sh
```

### Reload configurations

- **Hyprland**: `Super + Ctrl + R` (reloads Hyprland + Waybar)
- **Waybar only**: `Super + Ctrl + Shift + R`

## Hyprland Shortcuts

| Shortcut | Action |
|----------|--------|
| `Super + Return` | Open terminal (kitty) |
| `Super + R` | Open menu (rofi) |
| `Super + B` | Open Brave |
| `Super + N` | Open Neovim |
| `Super + Q` | Close window |
| `Super + J/K/H/L` | Move focus |
| `Super + Shift + J/K/H/L` | Move window |
| `Super + 1-0` | Workspaces |
| `Print` | Screenshot (selection) |
| `Shift + Print` | Screenshot (fullscreen) |
| `Super + O` | Screenshot with satty (selection) |
| `Super + Shift + O` | Screenshot with satty (fullscreen) |
| `Super + =/-` | Volume +/- |
| `Super + M` | Mute |
| `Super + .` | Brightness + |
| `Super + ,` | Brightness - |
| `Super + P` | Suspend |
| `Super + X` | Power menu |
| `Super + L` | Lock screen |

## Dotfiles Structure

```
dotfiles/
├── hypr/.config/hypr/           # Hyprland config
│   └── scripts/                   # Hypr scripts (monitor, wallpaper)
├── waybar/.config/waybar/       # Waybar config
│   └── scripts/                   # Waybar scripts (bluetooth)
├── rofi/.config/rofi/           # Rofi themes
├── zsh/.zshrc                   # Zsh config
├── kitty/.config/kitty/         # Kitty terminal
│   └── themes/                    # Kitty themes
├── nvim/.config/nvim/            # Neovim config
├── tmux/.tmux.conf               # Tmux config
├── git/.gitconfig                # Git config
├── yazi/                         # Yazi config
├── ruff/ruff.toml                # Ruff config
├── dunst/.config/dunst/          # Dunst notifications
├── images/                       # Images source
│   ├── screenshots/                # → ~/screenshots (symlink)
│   └── wallpapers/                 # → ~/wallpapers (symlink)
├── scripts/                      # Utility scripts
│   ├── setup-hyprland.sh         # Main installer
│   ├── install-nerdfonts.sh     # Install Nerd Fonts
│   ├── slugify.sh               # Slugify filenames
│   ├── conventional_commits.sh   # Generate conventional commits
│   └── pocket_plan_score.sh     # Score calculator
├── sddm/install-sddm-theme.sh    # SDDM theme installer (sudo)
│   └── usr/share/sddm/themes/    # SDDM theme files
└── .tmux/                        # Tmux plugin config
```

## Installed Packages

### Official repository (pacman)

**Desktop:**
- hyprland, hypridle, hyprlock, xdg-desktop-portal-hyprland
- waybar, rofi, dunst, sddm
- brightnessctl, pavucontrol
- networkmanager, network-manager-applet
- blueman, bluez, bluez-utils

**Tools:**
- git, kitty, tmux, zsh
- firefox, mpv, fastfetch, zathura-pdf-mupdf
- eza, zoxide, yazi, stow
- grim, slurp, wl-clipboard, playerctl, awww, satty
- noto-fonts-emoji, papirus-icon-theme
- tree, wget, unzip, fd, fzf, glow
- nodejs, npm, docker, docker-compose

**Video drivers:**
- nvidia/nvidia-open/amd/intel + mesa

### AUR (yay)

- brave-bin
- neovim-nightly-bin

## Utility Scripts

### `scripts/slugify.sh`
Rename files to slug format:
```bash
./scripts/slugify.sh filename\ with\ spaces.txt
# → filename-with-spaces.txt
```

### `scripts/conventional_commits.sh`
Generate conventional commit messages:
```bash
./scripts/conventional_commits.sh
```

### `scripts/pocket_plan_score.sh`
Calculate Pocket Plan scores:
```bash
./scripts/pocket_plan_score.sh
```

### `scripts/install-nerdfonts.sh`
Install Nerd Fonts:
```bash
./scripts/install-nerdfonts.sh
```

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

### Dunst doesn't show notifications
```bash
killall dunst
dunst &
```

### Wallpaper doesn't load after reboot
```bash
pkill awww-daemon
nohup awww-daemon &
sleep 1
awww img ~/wallpapers/default.jpg
```

### Monitor not detected correctly
```bash
hyprctl monitors all
hyprctl keyword monitor HDMI-A-2,preferred,0x0,1
```

## Tips

1. **Dotfiles organization**: All user-specific files are symlinked via GNU Stow
2. **Wallpapers**: Store in `~/wallpapers/`
3. **Screenshots**: Saved to `~/screenshots/`
4. **Scripts**: Available in `~/scripts/` (symlinked to `~/.local/bin` via PATH)
