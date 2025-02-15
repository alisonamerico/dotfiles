{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "alira";
  home.homeDirectory = "/home/alira";
  home.stateVersion = "24.05"; 

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".zshrc".source = ~/dotfiles/zshrc/.zshrc;
    ".config/wezterm".source = ~/dotfiles/wezterm;
    ".config/starship".source = ~/dotfiles/starship;
    ".config/nvim".source = ~/dotfiles/nvim;
    ".config/tmux".source = ~/dotfiles/tmux;
    ".config/yazi".source = ~/dotfiles/yazi;
    ".config/hypr".source = ~/dotfiles/hypr;
    ".config/waybar".source = ~/dotfiles/waybar;
  }

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
      discord
      libreoffice
      wezterm
      dbeaver
      neovim
      startship
      zsh
      yazi
      tmux
      keepassxc
      obsidian
      # lazygit
    ];

  # Config. Zsh
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  programs.zsh.ohMyZsh.theme = "agnoster"; # Exemplo de tema
  programs.zsh.ohMyZsh.plugins = [ "git" "docker", "zsh-autosuggestions", "zsh-syntax-highlighting" ];


  # Enable font configuration
  fonts.enable = true;

  # Specify the fonts you want to install
  fonts.fonts = with pkgs; [
    # Icon fonts
    material-design-icons

    # Normal fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji

    # Font Awesome
    font-awesome

    # nerdfonts
    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})

    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  ];

  # Enable pyenv
  programs.pyenv.enable = true;

  # Optionally, you can specify the Python versions you want to install
  programs.pyenv.versions = [
    # "3.9.7"  # Example version
    # "3.8.12" # Another example version
  ];

  # Optionally, set a global Python version
  programs.pyenv.globalVersion = "3.12.0"; # Set your desired global version

  # Enable Neovim
  programs.neovim.enable = true;
  # programs.neovim.package = pkgs.neovim;

  # Enable prompt for shell
  programs.starship.enable = true;

  # Enable terminal multiplexer
  programs.tmux.enable = true;

  # Enable terminal emulator
  programs.wezterm.enable = true;

  # Enable file manager
  programs.yazi.enable = true;

}

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
