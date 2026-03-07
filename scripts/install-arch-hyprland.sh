#!/bin/bash

set -e

# ============================================
# Script de Instalação - Arch Linux + Hyprland
# ============================================

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Funções de output
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Pausa para o usuário ler
pause() {
    echo ""
    read -p "Pressione Enter para continuar... "
}

# Verifica se é Arch Linux
check_arch() {
    info "Verificando sistema..."
    if [[ ! -f /etc/arch-release ]]; then
        error "Este script é apenas para Arch Linux!"
        exit 1
    fi
    success "Sistema detectado: Arch Linux"
}

# Verifica se tem yay
check_yay() {
    info "Verificando yay..."
    if ! command -v yay &> /dev/null; then
        warn "yay não encontrado. Instalando..."
        install_yay
    else
        success "yay já instalado"
    fi
}

# Instala yay
install_yay() {
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
    success "yay instalado"
}

# Detecta CPU
detect_cpu() {
    info "Detectando CPU..."
    vendor=$(grep -m1 "Vendor ID" /proc/cpuinfo | awk '{print $3}')
    if [[ "$vendor" == "GenuineIntel" ]]; then
        CPU="intel"
        UCODE="intel-ucode"
    elif [[ "$vendor" == "AuthenticAMD" ]]; then
        CPU="amd"
        UCODE="amd-ucode"
    else
        CPU="unknown"
        UCODE="intel-ucode"
    fi
    success "CPU detectada: $CPU"
}

# Escolha de driver de vídeo
choose_video_driver() {
    echo ""
    info "Escolha o driver de vídeo:"
    echo "  [1] Nvidia (open source)"
    echo "  [2] AMD (mesa)"
    echo "  [3] Intel (mesa)"
    echo "  [4] Nvidia (proprietário)"
    read -p "Opção [1-4]: " driver_choice

    case $driver_choice in
        1) VIDEO_DRIVER="nvidia";;
        2) VIDEO_DRIVER="mesa";;
        3) VIDEO_DRIVER="intel";;
        4) VIDEO_DRIVER="nvidia-proprietary";;
        *) VIDEO_DRIVER="nvidia";;
    esac
    success "Driver selecionado: $VIDEO_DRIVER"
}

# Instala pacotes oficiais
install_official_packages() {
    info "Instalando pacotes oficiais..."

    local packages=(
        # Sistema base
        "base"
        "base-devel"
        "linux"
        "linux-headers"
        "linux-firmware"
        "$UCODE"

        # Hyprland
        "hyprland"
        "hypridle"
        "hyprlock"
        "hyprsunset"
        "xdg-desktop-portal-hyprland"

        # UI/Bars
        "waybar"
        "dunst"
        "rofi"
        "sddm"

        # Ferramentas Wayland
        "grim"
        "slurp"
        "satty"
        "nwg-displays"
        "nwg-look"

        # Áudio
        "pipewire"
        "pipewire-alsa"
        "pipewire-pulse"
        "pipewire-jack"
        "libpulse"
        "wireplumber"
        "pavucontrol"
        "gst-plugin-pipewire"

        # Desenvolvimento
        "git"
        "go"
        "rust"
        "nodejs"
        "npm"
        "docker"
        "docker-compose"
        "neovim"
        "kitty"

        # Aplicativos
        "mpv"
        "zathura"
        "firefox"

        # Fontes
        "noto-fonts-emoji"
        "ttf-dejavu"
        "ttf-jetbrains-mono-nerd"
        "ttf-nerd-fonts-symbols"
        "ttf-nerd-fonts-symbols-common"
        "ttf-roboto"

        # Utilitários
        "networkmanager"
        "network-manager-applet"
        "blueman"
        "bluez"
        "bluez-utils"
        "fastfetch"
        "eza"
        "fd"
        "tree"
        "wget"
        "unzip"
        "tmux"
        "zsh"
        "stow"
        "zoxide"
        "yazi"
        "udiskie"
        "brightnessctl"
        "pamixer"
        "polkit-gnome"
        "libnotify"
        "imagemagick"
        "zsh-syntax-highlighting"

        # Drivers
        "libxcrypt-compat"
    )

    # Adicionar driver de vídeo conforme escolha
    case $VIDEO_DRIVER in
        nvidia|nvidia-proprietary)
            packages+=("nvidia-open" "nvidia-utils" "nvidia-settings")
            ;;
        mesa)
            packages+=("mesa" "mesa-vdpau" "libva-mesa-driver")
            ;;
        intel)
            packages+=("mesa" "intel-media-driver" "libva-intel-driver")
            ;;
    esac

    sudo pacman -S --noconfirm "${packages[@]}"
    success "Pacotes oficiais instalados"
}

# Instala pacotes do AUR
install_aur_packages() {
    info "Instalando pacotes do AUR..."

    local aur_packages=(
        "brave-bin"
    )

    yay -S --noconfirm "${aur_packages[@]}"
    success "Pacotes AUR instalados"
}

# Configura systemd
configure_systemd() {
    info "Configurando serviços systemd..."

    local services=(
        "NetworkManager"
        "bluetooth"
        "docker"
        "pipewire"
        "pipewire-pulse"
        "sddm"
    )

    for service in "${services[@]}"; do
        if sudo systemctl enable "$service" 2>/dev/null; then
            success "$service habilitado"
        else
            warn "Falha ao habilitar $service"
        fi
    done

    # Adicionar usuário ao grupo docker
    sudo usermod -aG docker "$USER"
    success "Usuário adicionado ao grupo docker"
}

# Configura mkinitcpio
configure_mkinitcpio() {
    info "Configurando mkinitcpio..."

    # Backup
    sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak
    success "Backup criado: /etc/mkinitcpio.conf.bak"

    # Adicionar módulos ao mkinitcpio.conf
    case $VIDEO_DRIVER in
        nvidia|nvidia-proprietary)
            sudo sed -i 's/^MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
            ;;
        intel)
            sudo sed -i 's/^MODULES=()/MODULES=(i915)/' /etc/mkinitcpio.conf
            ;;
    esac

    # Adicionar ucode
    if [[ "$UCODE" == "intel-ucode" ]]; then
        sudo sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect keyboard keymap consolefont modconf block encrypt lvm2 filesystems resume fsck usr intel-ucode)/' /etc/mkinitcpio.conf
    else
        sudo sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect keyboard keymap consolefont modconf block encrypt lvm2 filesystems resume fsck usr amd-ucode)/' /etc/mkinitcpio.conf
    fi

    # Regenerar initcpio
    info "Regenerando initcpio (isso pode levar alguns minutos)..."
    sudo mkinitcpio -P
    success "mkinitcpio configurado"
}

# Clonar dotfiles
clone_dotfiles() {
    info "Clonando dotfiles..."

    if [[ -d ~/dotfiles ]]; then
        warn "Diretório ~/dotfiles já existe. Deseja sobrescrever? [s/N]"
        read -r response
        if [[ "$response" =~ ^[Ss]$ ]]; then
            rm -rf ~/dotfiles
        else
            info "Pulando clonagem de dotfiles"
            return
        fi
    fi

    git clone https://github.com/alisonamerico/dotfiles ~/dotfiles
    success "Dotfiles clonados"
}

# Configura zsh
configure_zsh() {
    info "Configurando zsh..."

    # Instalar oh-my-zsh se não existir
    if [[ ! -d ~/.oh-my-zsh ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        success "oh-my-zsh instalado"
    else
        info "oh-my-zsh já instalado"
    fi

    # Clonar zsh-syntax-highlighting
    if [[ ! -d ~/.zsh/plugins/zsh-syntax-highlighting ]]; then
        mkdir -p ~/.zsh/plugins
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting
        success "zsh-syntax-highlighting clonado"
    else
        info "zsh-syntax-highlighting já existe"
    fi

    # Criar symlink do .zshrc
    if [[ -f ~/dotfiles/zsh/.zshrc ]]; then
        ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
        success "Symlink do .zshrc criado"
    else
        warn "Arquivo ~/dotfiles/zsh/.zshrc não encontrado"
    fi
}

# Configura stow
configure_stow() {
    info "Configurando dotfiles com stow..."
    cd ~/dotfiles

    # Criar diretórios necessários
    mkdir -p ~/.config

    # Listar disponíveis para stow
    echo ""
    info "Pacotes disponíveis para stow:"
    ls -d */ 2>/dev/null | sed 's|/||' | grep -v ".git" | grep -v "backup"

    echo ""
    read -p "Quais pacotes deseja aplicar com stow? (ex: nvim zsh tmux kitty): " packages

    if [[ -n "$packages" ]]; then
        for pkg in $packages; do
            if [[ -d "$pkg" ]]; then
                stow -v -t ~ "$pkg" 2>/dev/null || warn "Falha ao aplicar stow para $pkg"
            else
                warn "Pacote $pkg não encontrado"
            fi
        done
    fi

    success "Stow configurado"
}

# Resumo final
show_summary() {
    echo ""
    echo "============================================"
    echo -e "${GREEN}INSTALAÇÃO CONCLUÍDA!${NC}"
    echo "============================================"
    echo ""
    echo "=== Configurado automaticamente ==="
    echo "  [✓] Pacotes oficiais instalados"
    echo "  [✓] Pacotes AUR instalados"
    echo "  [✓] Serviços systemd habilitados"
    echo "  [✓] mkinitcpio configurado"
    echo "  [✓] Dotfiles clonados"
    echo "  [✓] zsh configurado"
    echo "  [✓] stow aplicado"
    echo ""
    echo "=== Necessário configurar manualmente ==="
    echo "  [!] Git: git config --global user.name 'Seu Nome'"
    echo "  [!] Git: git config --global user.email 'seu@email.com'"
    echo "  [!] Hyprland: Editar ~/.config/hypr/hyprland.conf"
    echo "  [!] Waybar: Editar ~/.config/waybar/config"
    echo "  [!] Dunst: Editar ~/.config/dunst/dunstrc"
    echo "  [!] Rofi: Editar ~/.config/rofi/config.rasi"
    echo "  [!] Neovim: Editar ~/.config/nvim/"
    echo "  [!] Kitty: Editar ~/.config/kitty/kitty.conf"
    echo "  [!] Tmux: Editar ~/.tmux.conf"
    echo "  [!] Reiniciar o sistema para aplicar mudanças"
    echo ""
    echo "=== Driver de vídeo instalado ==="
    echo "  Driver: $VIDEO_DRIVER"
    echo ""
    echo "  Para verificar drivers carregados:"
    echo "    lspci -k | grep -A 3 -E 'VGA|3D'"
    echo ""
}

# Main
main() {
    echo ""
    echo "============================================"
    echo "  Instalação Arch Linux + Hyprland"
    echo "============================================"
    echo ""

    check_arch
    pause

    check_yay
    pause

    detect_cpu
    pause

    choose_video_driver
    pause

    info "Iniciando instalação de pacotes oficiais..."
    install_official_packages
    pause

    info "Iniciando instalação de pacotes AUR..."
    install_aur_packages
    pause

    configure_systemd
    pause

    configure_mkinitcpio
    pause

    clone_dotfiles
    pause

    configure_zsh
    pause

    configure_stow
    pause

    show_summary
}

# Executar
main
