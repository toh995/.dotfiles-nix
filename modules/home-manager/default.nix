{ pkgs, ... }:

let pyEnv = pkgs.python3.withPackages (p: [pkgs.qtile-unwrapped]);

in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.toh995 = {
    # DO NOT CHANGE
    home.stateVersion = "22.11";

    programs.home-manager.enable = true;

    # Auto-start qtile on login
    programs.zsh = {
      enable = true;
      # profileExtra = ''
      #   if [ -z $DISPLAY ] && [ $XDG_VTNR -eq 1 ]; then
      #     ${pyEnv}/bin/qtile start -b wayland
      #     ${pyEnv}/bin/qtile start -b wayland --config $HOME/.dotfiles-nix/modules/home-manager/qtile/config.py
      #   fi
      # '';
    };

    # Set some default env vars
    home.sessionVariables = {
      BROWSER = "brave";
      EDITOR = "nvim";
      PAGER = "less";
      VISUAL = "nvim";
    };

    # Allow font installations
    fonts.fontconfig.enable = true;


    home.packages = with pkgs; [
      # GUI programs
      alacritty
      brave
      dunst
      firefox
      keepassxc
      rofi

      udiskie

      # CLI programs
      btop
      delta
      git
      lazydocker
      lazygit
      mpv
      neofetch
      nnn
      ripgrep
      spotify-player
      tealdeer
      tmux
      trash-cli
      youtube-dl
      zoxide

      # CLI utils
      libnotify # send notifications
      pamixer # introspect on sound
      xdg-utils # xdg-open

      # powerlevel10k, font
      zsh-powerlevel10k
      # meslo-lgs-nf
      # (pkgs.nerdfonts.override { fonts = [ "AnonymousPro" "CascadiaCode" "DroidSansMono" "FiraCode" "Monoid" "RobotoMono" "SpaceMono" "UbuntuMono" "VictorMono"]; })
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

      # Neovim
      neovim
      # NOTE:
      # Normally, we would use mason.nvim to install
      # language servers and formatters.
      #
      # In particular, mason.nvim will download binaries for each 
      # language server and formatter.
      #
      # HOWEVER, this is problematic for NixOS - generally speaking,
      # the distro won't run binaries, unless they are installed by
      # Nix itself.
      #
      # So we'll install the language servers and formatters here.

      # lua
      lua-language-server
      stylua
      # nix
      nil
      # python
      black # formatter
      # nodePackages.pyright # type-checker
      python311Packages.python-lsp-server
      ruff # linter
      ruff-lsp

      # build dependencies
      # for nvim-treesitter
      gcc
      # for markdown-preview
      nodejs_20
      yarn
    ];

    imports = [
      ./alacritty
      ./bash
      ./brave
      ./dunst
      ./firefox
      ./git
      ./lazygit
      ./python
      ./qtile
      ./rofi
      ./spotify-player
      ./tealdeer
      ./tmux
      ./udiskie
      ./xdg
      ./zsh
    ];
  };
}
