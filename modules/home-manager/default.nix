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

    home.packages = with pkgs; [
      # window manager
      hyprland

      # GUI programs
      alacritty # todo: configure alacritty, with appropriate font
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
      neovim # todo: configure
      nnn
      ripgrep
      tmux # todo: configure
      trash-cli
      youtube-dl
      zoxide

      # todo: different terminal theme...?
      # todo: install nerdfont...?
      # zsh-powerlevel10k

      # todo: spotify-tui??
    ];

    imports = [
      ./git
      ./lazygit
      ./xdg
      ./zsh
    ];
  };
}
