# Configurações do Home Manager para o ambiente de trabalho.
{ config, pkgs, ... }:

{
  home.username = "yourusername"; # Substitua pelo seu nome de usuário

  home.file.".zshrc".source = ./dotfiles/.zshrc;
  home.file.".vimrc".source = ./dotfiles/.vimrc;
  home.file.".gitconfig".source = ./dotfiles/.gitconfig;

  programs.z

