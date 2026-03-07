#!/usr/bin/env bash

set -euo pipefail

# ============================================
# Smart Installer - Arch Linux + Hyprland
# Idempotent and conflict-aware
# ============================================

LOG_FILE="$HOME/arch-hyprland-install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

pause() {
    echo ""
    read -rp "Pressione Enter para continuar... "
}

check_arch() {
    info "Verificando sistema..."
    if [[ ! -f /etc/arch-release ]]; then
        error "Este script é apenas para Arch Linux!"
        exit 1
    fi
    success "Sistema detectado: Arch Linux"
}

detect_cpu() {
    info "Detectando CPU..."
    vendor=$(grep -m1 "vendor_id" /proc/cpuinfo | awk '{print $3}')

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

check_yay() {
    if command -v yay &>/dev/null; then
        success "yay já instalado"
        return
    fi

    warn "yay não encontrado. Instalando..."

    sudo pacman -S --needed --noconfirm git base-devel

    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay

    success "yay instalado"
}

install_pkg() {
    local pkg=$1

    if pacman -Q "$pkg" &>/dev/null; then
        info "$pkg já instalado"
        return
    fi

    info "Instalando $pkg"

    if sudo pacman -S --needed --noconfirm "$pkg"; then
        success "$pkg instalado"
    else
        warn "Falha ao instalar $pkg (ignorando)"
    fi
}

install_aur_pkg() {
    local pkg=$1

    if pacman -Q "$pkg" &>/dev/null; then
        info "$pkg já instalado"
        return
    fi

    info "Instalando AUR $pkg"

    if yay -S --noconfirm "$pkg"; then
        success "$pkg instalado"
    else
        warn "Falha ao instalar $pkg"
    fi
}

fix_audio_conflicts() {
    info "Verificando conflitos de áudio..."

    if pacman -Q jack2 &>/dev/null; then
        warn "Removendo jack2 (conflito com pipewire-jack)"
        sudo pacman -Rns --noconfirm jack2
    fi

    if pacman -Q jack2-dbus &>/dev/null; then
        warn "Removendo jack2-dbus"
        sudo pacman -Rns --noconfirm jack2-dbus
    fi
}

choose_video_driver() {

    echo ""
    echo "Escolha o driver de vídeo:"
    echo "  [1] Nvidia (open)"
    echo "  [2] AMD"
    echo "  [3] Intel"
    echo "  [4] Nvidia proprietário"

    read -rp "Opção: " driver_choice

    case $driver_choice in
        1) VIDEO_DRIVER="nvidia-open";;
        2) VIDEO_DRIVER="amd";;
        3) VIDEO_DRIVER="intel";;
        4) VIDEO_DRIVER="nvidia";;
        *) VIDEO_DRIVER="intel";;
    esac

    success "Driver selecionado: $VIDEO_DRIVER"
}

install_packages() {

    info "Instalando pacotes principais..."

    packages=(
        base
        linux
        linux-headers
        linux-firmware
        "$UCODE"

        hyprland
        hypridle
        hyprlock
        hyprsunset
        xdg-desktop-portal-hyprland

        waybar
        dunst
        rofi
        sddm

        pipewire
        pipewire-alsa
        pipewire-pulse
        pipewire-jack
        wireplumber
        pavucontrol

        networkmanager
        network-manager-applet

        bluez
        bluez-utils
        blueman

        git
        neovim
        kitty
        tmux
        zsh

        firefox
        mpv

        docker
        docker-compose

        fastfetch
        tree
        wget
        unzip
        fd
        eza
        zoxide
        yazi
        stow
    )

    case $VIDEO_DRIVER in

        nvidia-open)
            packages+=(nvidia-open nvidia-utils nvidia-settings)
            ;;

        nvidia)
            packages+=(nvidia nvidia-utils nvidia-settings)
            ;;

        amd)
            packages+=(mesa mesa-vdpau libva-mesa-driver)
            ;;

        intel)
            packages+=(mesa intel-media-driver libva-intel-driver)
            ;;

    esac

    for pkg in "${packages[@]}"; do
        install_pkg "$pkg"
    done
}

install_aur_packages() {

    aur_packages=(
        brave-bin
    )

    for pkg in "${aur_packages[@]}"; do
        install_aur_pkg "$pkg"
    done
}

enable_service() {

    local service=$1

    if systemctl is-enabled "$service" &>/dev/null; then
        info "$service já habilitado"
    else
        sudo systemctl enable "$service"
        success "$service habilitado"
    fi
}

configure_services() {

    services=(
        NetworkManager
        bluetooth
        docker
        sddm
    )

    for service in "${services[@]}"; do
        enable_service "$service"
    done

    sudo usermod -aG docker "$USER"

}

clone_dotfiles() {

    if [[ -d "$HOME/dotfiles" ]]; then
        warn "Diretório ~/dotfiles já existe"
        return
    fi

    info "Clonando dotfiles"

    git clone https://github.com/alisonamerico/dotfiles "$HOME/dotfiles"

}

configure_zsh() {

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then

        info "Instalando oh-my-zsh"

        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    fi

    if [[ -f "$HOME/dotfiles/zsh/.zshrc" ]]; then
        ln -sf "$HOME/dotfiles/zsh/.zshrc" "$HOME/.zshrc"
    fi

}

configure_stow() {

    if [[ ! -d "$HOME/dotfiles" ]]; then
        warn "Dotfiles não encontrados"
        return
    fi

    cd "$HOME/dotfiles"

    mkdir -p "$HOME/.config"

    info "Pacotes disponíveis:"
    ls -d */ | sed 's#/##'

    echo ""
    read -rp "Quais pacotes aplicar com stow? " packages

    for pkg in $packages; do

        if [[ -d "$pkg" ]]; then

            stow -v -t "$HOME" "$pkg"

        else

            warn "$pkg não encontrado"

        fi

    done

}

summary() {

echo ""
echo "================================"
echo "Instalação concluída"
echo "================================"

echo "Log salvo em:"
echo "$LOG_FILE"

echo ""
echo "Recomendações:"
echo " - Reiniciar sistema"
echo " - Configurar git"
echo " - Ajustar configs do Hyprland"

}

main() {

echo ""
echo "================================"
echo " Arch + Hyprland Smart Installer"
echo "================================"
echo ""

check_arch
pause

detect_cpu
pause

check_yay
pause

fix_audio_conflicts
pause

choose_video_driver
pause

install_packages
pause

install_aur_packages
pause

configure_services
pause

clone_dotfiles
pause

configure_zsh
pause

configure_stow
pause

summary

}

main
