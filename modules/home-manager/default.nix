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
      neovim
      nnn
      ripgrep
      tmux
      trash-cli
      youtube-dl
      # zoxide
      # zsh-autosuggestions
      # zsh-syntax-highlighting

      # todo: different terminal theme...?
      # todo: install nerdfont...?
      # zsh-powerlevel10k
    ];

    imports = [
      ./git
      ./lazygit
    ];
  };
}
