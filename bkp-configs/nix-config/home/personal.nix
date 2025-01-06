# Configurações do Home Manager para o ambiente pessoal.
{ config, pkgs, ... }:

{
  home.username = "yourusername"; # Substitua pelo seu nome de usuário

  # Configurações de dotfiles
  home.file.".zshrc".source = ./dotfiles/.zshrc;
  home.file.".vimrc".source = ./dotfiles/.vimrc;
  home.file.".gitconfig".source = ./dotfiles/.gitconfig;

  # Habilita o Zsh
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  programs.zsh.ohMyZsh.theme = "agnoster"; # Exemplo de tema

  # Habilita o Neovim
  programs.neovim.enable = true;
  programs.neovim.package = pkgs.neovim;

  # Habilita o Waybar (barra de status para Wayland)
  programs.waybar.enable = true;

  # Habilita o Sway (opcional, se você quiser usar como gerenciador de janelas)
  programs.sway.enable = true;

  # Outras configurações do Home Manager
}

