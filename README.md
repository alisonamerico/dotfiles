# Arch Linux + Hyprland Setup

Script de instalação automática para Arch Linux com Hyprland.

## Pré-requisitos

1. Arch Linux instalado
2. Acesso à internet
3. Usuário com privilégios sudo

## Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Dê permissão de execução ao script

```bash
chmod +x scripts/install-arch-hyprland-smart.sh
```

### 3. Execute o script

```bash
./scripts/install-arch-hyprland-smart.sh
```

O scriptirá pedir para você escolher:
- CPU (Intel/AMD)
- Driver de vídeo (Nvidia/AMD/Intel)
- Quais pacotes instalar
- Quais dotfiles aplicar com stow

## Pós-instalação

### Aplicar configurações com Stow

Após a instalação, para aplicar as configurações:

```bash
cd ~/dotfiles

# Verificar pacotes disponíveis
ls -d */

# Aplicar todos de uma vez
stow -t $HOME hypr waybar rofi zsh kitty nvim tmux gitconfig yazi ruff

# Ou aplicar individualmente
stow -t $HOME hypr
stow -t $HOME waybar
stow -t $HOME rofi
stow -t $HOME zsh
stow -t $HOME kitty
stow -t $HOME nvim
stow -t $HOME tmux
stow -t $HOME gitconfig
stow -t $HOME yazi
stow -t $HOME ruff
```

### Recarregar configurações

- **Hyprland**: `Super + Ctrl + R` (recarrega Hyprland + Waybar)
- **Waybar only**: `Super + Ctrl + Shift + R`

## Atalhos do Hyprland

| Atalho | Ação |
|--------|------|
| `Super + R` | Abrir menu (rofi) |
| `Super + B` | Abrir Brave |
| `Super + N` | Abrir Neovim |
| `Super + Q` | Fechar janela |
| `Super + J/K/H/L` | Mover foco |
| `Super + Shift + J/K/H/L` | Mover janela |
| `Super + 1-0` | Workspaces |
| `Print` | Screenshot (seleção) |
| `Super + =/-` | Volume +/- |
| `Super + M` | Mutar |
| `Super + ,/.` | Brilho +/- |

## Estrutura dos Dotfiles

```
dotfiles/
├── hypr/.config/hypr/      # Hyprland config
├── waybar/.config/waybar/  # Waybar config
├── rofi/.config/rofi/      # Rofi themes
├── zsh/.zshrc             # Zsh config
├── kitty/.config/kitty/   # Kitty terminal
├── nvim/.config/nvim/     # Neovim config
├── tmux/.tmux.conf       # Tmux config
├── gitconfig/.gitconfig   # Git config
├── yazi/                  # Yazi config
├── ruff/ruff.toml         # Ruff config
└── scripts/              # Install scripts
```

## Pacotes instalados

### Repositório oficial (pacman)
- hyprland, hypridle, hyprlock
- waybar, rofi, dunst, sddm
- brightnessctl, pavucontrol
- networkmanager, blueman
- git, kitty, tmux, zsh
- firefox, mpv, fastfetch
- eza, zoxide, yazi, stow
- grim, slurp, wl-clipboard, playerctl
- noto-fonts-emoji, papirus-icon-theme

### AUR (yay)
- brave-bin
- neovim-nightly-bin

## Solução de problemas

### Waybar não aparece
```bash
killall waybar
waybar &
```

### Config não carrega
```bash
hyprctl reload
```

### Áudio não funciona
Verificar se o PipeWire está rodando:
```bash
systemctl --user status pipewire
```

### Bluetooth não funciona
```bash
blueman-manager
```

## Autor

Alison
