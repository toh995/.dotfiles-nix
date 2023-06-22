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

    # Auto-start hyprland on login
    programs.zsh = {
      enable = true;
      profileExtra = ''
        if [ -z $DISPLAY ] && [ $XDG_VTNR -eq 1 ]; then
          # ${pyEnv}/bin/qtile start -b wayland
          # exec Hyprland
          # exec Hyprland --config $HOME/.dotfiles-nix/modules/home-manager/hyprland/hyprland.conf
        fi
      '';
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
      # Window manager
      eww-wayland
      hyprland

      # GUI programs
      alacritty
      brave

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
      tldr
      tmux
      trash-cli
      youtube-dl
      zoxide

      # powerlevel10k, font
      zsh-powerlevel10k
      meslo-lgs-nf
      #(pkgs.nerdfonts.override { fonts = [ "BigBlueTerminal" ]; })

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
      python311Packages.ruff-lsp

      # build dependencies
      gcc # for nvim-treesitter

      # todo: spotify-tui??
    ];

    imports = [
      ./alacritty
      ./brave
      ./eww
      ./git
      ./hyprland
      ./lazygit
      ./nvim
      ./qtile
      ./tmux
      ./xdg
      ./zsh
    ];
  };
}
