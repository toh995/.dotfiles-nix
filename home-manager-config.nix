{ home-manager, pkgs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.toh995 = {
    # DO NOT CHANGE
    home.stateVersion = "22.11";

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      # window manager
      hyprland

      # CLI programs
      git
      neovim
      tmux

      # GUI programs
      brave
      kitty
    ];
  };
}
