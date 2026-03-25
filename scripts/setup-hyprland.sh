#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="$HOME/arch-hyprland-install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

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

    case "$vendor" in
        GenuineIntel)
            CPU="intel"
            UCODE="intel-ucode"
            ;;
        AuthenticAMD)
            CPU="amd"
            UCODE="amd-ucode"
            ;;
        *)
            CPU="unknown"
            UCODE="intel-ucode"
            ;;
    esac

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
        warn "Falha ao instalar $pkg"
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

choose_video_driver() {

    echo ""
    echo "Escolha o driver de vídeo:"
    echo "  [1] Nvidia open"
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
        xdg-desktop-portal-hyprland

        waybar
        dunst
        rofi
        sddm
        brightnessctl
        pavucontrol

        networkmanager
        network-manager-applet

        bluez
        bluez-utils
        blueman

        git
        kitty
        tmux
        zsh

        firefox
        mpv

        fastfetch
        tree
        wget
        unzip
        fd
        fzf
        glow
        eza
        zoxide
        yazi
        stow
        awww
        imagemagick
        grim
        satty
        zathura-pdf-mupdf
        slurp
        wl-clipboard
        playerctl
        noto-fonts-emoji
        papirus-icon-theme
        nodejs
        npm
        docker
        docker-compose
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

    if pacman -Qq neovim &>/dev/null; then
        info "Removendo neovim estável..."
        sudo pacman -R neovim --noconfirm 2>/dev/null || true
    fi

    aur_packages=(
        brave-bin
        neovim-nightly-bin
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
        sddm
    )

    for service in "${services[@]}"; do
        enable_service "$service"
    done
}

configure_sddm() {

    if [[ -d "$HOME/dotfiles/sddm" ]]; then

        info "Configurando SDDM..."

        info "Configurando SDDM..."

        sudo rm -rf /usr/share/sddm/themes/where_is_my_sddm_theme
        sudo cp -r "$HOME/dotfiles/sddm/usr/share/sddm/themes/where_is_my_sddm_theme" /usr/share/sddm/themes/
        success "Tema where_is_my_sddm_theme instalado"

        if grep -q "^Current=.*" /etc/sddm.conf 2>/dev/null; then
            sudo sed -i 's/Current=.*/Current=where_is_my_sddm_theme/' /etc/sddm.conf
        else
            echo -e "\n[Theme]\nCurrent=where_is_my_sddm_theme" | sudo tee -a /etc/sddm.conf > /dev/null
        fi
        success "SDDM configurado"

    fi
}

clone_dotfiles() {

    if [[ -d "$HOME/dotfiles" ]]; then
        warn "Diretório ~/dotfiles já existe"
        return
    fi

    info "Clonando dotfiles"

    git clone https://github.com/alisonamerico/dotfiles "$HOME/dotfiles"
}

install_uv() {
    info "Instalando uv..."
    if command -v uv &>/dev/null; then
        success "uv já instalado: $(uv --version)"
    else
        curl -LsSf https://astral.sh/uv/install.sh | sh
        source "$HOME/.local/bin/env" 2>/dev/null || true
        success "uv instalado"
    fi
    
    info "Instalando ferramentas uv globais..."
    uv tool install ruff
    uv tool install taplo
    uv tool install djlint
    uv tool install mdformat
    success "Ferramentas instaladas"
}

configure_stow() {

    if [[ ! -d "$HOME/dotfiles" ]]; then
        warn "Dotfiles não encontrados"
        return
    fi

    local dotfiles_dir="$HOME/dotfiles"
    local current_dir="$PWD"

    cd "$dotfiles_dir"

    mkdir -p "$HOME/.config"

    if [[ -d "$HOME/.config/hypr" ]] && [[ ! -L "$HOME/.config/hypr" ]]; then
        warn "Removendo configurações padrão do Hyprland..."
        rm -rf "$HOME/.config/hypr"
    fi

    mkdir -p "$HOME/.config/hypr/scripts"

    info "Pacotes disponíveis:"
    ls -d */ | sed 's#/##'

    echo ""
    read -rp "Quais pacotes aplicar com stow? " packages

    if [[ -z "$packages" ]]; then
        info "Nenhum pacote selecionado, pulando..."
        cd "$current_dir"
        return
    fi

    local stow_opts="-v"

    for pkg in $packages; do

        if [[ -d "$pkg" ]]; then
            if stow -n $stow_opts -t "$HOME" "$pkg" 2>&1 | grep -q "would cause conflicts"; then
                info "Conflitos detectados para $pkg, usando --adopt..."
                stow $stow_opts --adopt -t "$HOME" "$pkg"
            else
                stow $stow_opts -t "$HOME" "$pkg"
            fi
        else
            warn "$pkg não encontrado"
        fi

    done

    if command -v waybar &>/dev/null; then
        info "Reiniciando waybar..."
        killall waybar 2>/dev/null || true
        waybar &
    fi

    cd "$current_dir"
}

install_nerd_fonts() {

    local fonts_dir="$HOME/.local/share/fonts"

    if [[ ! -d "$fonts_dir" ]]; then
        mkdir -p "$fonts_dir"
    fi

    info "Instalando Nerd Fonts..."

    declare -a fonts=(
        JetBrainsMono
        FiraCode
        Hack
        Ubuntu
    )

    local version="3.0.2"

    for font in "${fonts[@]}"; do
        local zip_file="${font}.zip"
        local download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"

        if [[ -f "$fonts_dir/${font}"*Nerd*Font*Complete* ]]; then
            info "$font já instalado"
            continue
        fi

        info "Baixando $font..."
        if wget -q "$download_url" -O "$zip_file"; then
            unzip -o "$zip_file" -d "$fonts_dir"
            rm -f "$zip_file"
            success "$font instalado"
        else
            warn "Falha ao baixar $font"
        fi
    done

    find "$fonts_dir" -name '*Windows Compatible*' -delete 2>/dev/null

    fc-cache -fv
    success "Fontes instaladas"
}

install_rofi_themes() {

    if [[ ! -d "$HOME/.config/rofi" ]]; then
        mkdir -p "$HOME/.config/rofi"
    fi

    info "Baixando temas rofi..."

    if [[ -d "/tmp/rofi" ]]; then
        rm -rf /tmp/rofi
    fi

    if git clone --depth=1 https://github.com/adi1090x/rofi.git /tmp/rofi; then
        cp /tmp/rofi/files/launchers/type-1/style-3.rasi "$HOME/.config/rofi/"
        cp -r /tmp/rofi/files/launchers/type-1/shared "$HOME/.config/rofi/"
        rm -rf /tmp/rofi
        success "Temas rofi instalados"
    else
        warn "Falha ao baixar temas rofi"
    fi
}

configure_icon_theme() {

    info "Configurando tema de ícones..."

    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
        success "Tema de ícones configurado"
    else
        warn "gsettings não disponível"
    fi
}

configure_kwallet() {

    info "Desabilitando KDE Wallet..."

    mkdir -p "$HOME/.config/kwalletd"
    echo -e "[Wallet]\nEnabled=false" > "$HOME/.config/kwalletrc"

    success "KDE Wallet desabilitado"
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

choose_video_driver
pause

install_packages
pause

install_aur_packages
pause

configure_services
pause

configure_sddm
pause

clone_dotfiles
pause

install_uv
pause

configure_stow
pause

install_nerd_fonts
pause

configure_zsh
pause

install_rofi_themes
pause

configure_icon_theme
pause

configure_kwallet
pause

summary

}

main
