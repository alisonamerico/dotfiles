# O módulo work.nix pode conter configurações específicas para a máquina de trabalho.
{ config, pkgs, ... }:

{
  # Configurações do sistema
  networking.hostName = "my-work-machine";

  # Configurações do ambiente de desktop (exemplo com Xfce)
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Instala alguns pacotes
  environment.systemPackages = with pkgs; [
    firefox
    libreoffice
    git
    vim
    htop
    neofetch
    zoom
    slack
  ];
}

