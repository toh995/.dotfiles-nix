{pkgs, ...}: let
  pyEnv = pkgs.python3.withPackages (p: [pkgs.qtile-unwrapped]);
in {
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
      MANPAGER = "less";
      PAGER = "less";
      VISUAL = "nvim";
    };

    # Allow font installations
    fonts.fontconfig.enable = true;

    # Set mouse cursor
    home.pointerCursor = {
      # package = pkgs.catppuccin-cursors.mochaDark;
      # name = "Catppuccin-Mocha-Dark-Cursors";
      # package = pkgs.phinger-cursors;
      # name = "phinger-cursors";
      # size = 32;
      package = pkgs.apple-cursor;
      name = "macOS-Monterey";
      size = 24;
      gtk.enable = true;
    };

    home.packages = with pkgs; [
      # GUI programs
      alacritty
      brave
      dunst
      firefox
      flameshot
      keepassxc
      libreoffice-fresh
      obsidian
      pcmanfm
      udiskie
      rofi
      zathura


      # CLI programs
      btop
      delta
      eza
      fzf
      git
      kopia
      lazygit
      mpv
      neofetch
      nnn
      rclone
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

      # zsh
      zsh-powerlevel10k
      zsh-vi-mode

      # Neovim
      vim
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

      # formatter
      efm-langserver
      # bash
      bats
      nodePackages_latest.bash-language-server
      shfmt
      # go
      # delve
      # golangci-lint
      # golangci-lint-langserver
      # gopls
      # haskell
      cabal-install
      ghc
      haskell-language-server
      haskellPackages.fourmolu
      # lua
      lua-language-server
      stylua
      # nix
      alejandra # formatter
      nil # lsp
      # python
      black # formatter
      # nodePackages.pyright # type-checker
      python311Packages.python-lsp-server
      ruff # linter
      ruff-lsp

      # nvim build dependencies
      # for nvim-treesitter
      gcc
      # for markdown-preview
      nodejs_20
      yarn
      # for telescope fzf
      gnumake
    ];

    imports = [
      ./alacritty
      ./bash
      ./brave
      ./dunst
      ./firefox
      ./flameshot
      ./git
      ./lazygit
      ./npm
      ./pcmanfm
      ./python
      ./qtile
      ./rofi
      ./scripts
      ./spotify-player
      ./tealdeer
      ./theming
      ./tmux
      ./udiskie
      ./xdg
      ./zathura
      ./zsh
    ];
  };
}
