{ home-manager, pkgs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.toh995 = {
    home.username = "toh995";
    home.homeDirectory = "/home/toh995";

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      neovim
      tmux
    ];

    # DO NOT CHANGE
    home.stateVersion = "22.11";
  };
}
