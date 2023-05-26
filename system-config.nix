{ config, pkgs, ... }:

{
  # DO NOT CHANGE
  system.stateVersion = "22.11";

  # Configure the bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Maximum number of latest generations in the boot menu
  boot.loader.systemd-boot.configurationLimit = 100;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable zsh
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  # Set up user account
  users.users.toh995 = {
    name = "toh995";
    home = "/home/toh995";
    createHome = true;
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
