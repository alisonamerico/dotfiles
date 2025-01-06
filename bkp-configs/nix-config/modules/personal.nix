{ config, pkgs, ... }:

{
  # Configurações do sistema
  networking.hostName = "my-personal-machine";

  # Habilita o serviço SSH
  services.openssh.enable = true;

  # Configurações do ambiente de desktop (Hyprland)
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = false; # Desabilita outros gerenciadores de exibição
  services.xserver.desktopManager.hyprland.enable = true; # Habilita o Hyprland

  # Configurações do Hyprland
  services.hyprland.enable = true;
  services.hyprland.config = ''
    # Adicione suas configurações do Hyprland aqui
    # Exemplo de configuração básica
    monitor=HDMI-A-1,1920x1080@60
    monitor=DP-1,1920x1080@60
    # Outros parâmetros de configuração do Hyprland
  '';

  # Instala alguns pacotes
  environment.systemPackages = with pkgs; [
    firefox
    vlc
    git
    vim
    htop
    neofetch
    hyprland
    wayland
    swaybg
    swaylock
    # Adicione outros pacotes que você deseja
  ];
}

