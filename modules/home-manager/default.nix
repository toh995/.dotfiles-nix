{ home-manager, pkgs, ... }:

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
          exec Hyprland
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
      # window manager
      hyprland

      # GUI programs
      alacritty
      brave
      kitty # todo: switch out kitty

      # CLI programs
      btop
      delta
      git
      lazydocker
      lazygit
      mpv
      neofetch
      neovim
      nnn
      ripgrep
      tmux
      trash-cli
      youtube-dl
      zoxide

      # powerlevel10k, font
      zsh-powerlevel10k
      meslo-lgs-nf
      #(pkgs.nerdfonts.override { fonts = [ "BigBlueTerminal" ]; })


      # todo: spotify-tui??
    ];

    imports = [
      ./alacritty
      ./git
      ./lazygit
      ./nvim
      ./tmux
      ./xdg
      ./zsh
    ];
  };
}
