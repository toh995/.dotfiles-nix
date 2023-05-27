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

  # Enable audio
  # Reference: https://nixos.wiki/wiki/PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable zsh
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  # Set up the user account
  users.users.toh995 = {
    name = "toh995";
    home = "/home/toh995";
    createHome = true;
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # Enable hyprland
  programs.hyprland.enable = true;
}
