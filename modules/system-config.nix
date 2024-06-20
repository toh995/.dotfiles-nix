{
  config,
  lib,
  pkgs,
  ...
}: {
  # DO NOT CHANGE
  system.stateVersion = "22.11";

  # Configure the bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Maximum number of latest generations in the boot menu
  boot.loader.systemd-boot.configurationLimit = 100;
  # Auto-select the first boot entry
  boot.loader.timeout = 0;

  # Set the timezone
  time.timeZone = "US/Pacific";
  # services.automatic-timezoned.enable = true;

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable dconf (needed for gtk)
  # https://discourse.nixos.org/t/error-gdbus-error-org-freedesktop-dbus-error-serviceunknown-the-name-ca-desrt-dconf-was-not-provided-by-any-service-files/29111
  programs.dconf.enable = true;

  # Enable qtile
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 25;

    windowManager.qtile = {
      enable = true;
      configFile = "${config.users.users.toh995.home}/.dotfiles-nix/modules/home-manager/qtile/config.py";
    };

    displayManager.lightdm = {
      enable = true;
      greeter.enable = false;
      autoLogin.timeout = 0;
    };
  };

  services.displayManager = {
    defaultSession = "qtile";
    autoLogin = {
      enable = true;
      user = "toh995";
    };
  };

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

  # fonts
  fonts = {
    packages = with pkgs; [
      # fonts
      noto-fonts
      noto-fonts-lgc-plus
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts-emoji-blob-bin
      noto-fonts-monochrome-emoji
      (pkgs.nerdfonts.override {fonts = ["DejaVuSansMono"];})
      # nerdfonts
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Serif"];
        sansSerif = ["Noto Sans"];
        monospace = ["Noto Sans Mono"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  # Enable udisks
  services.udisks2.enable = true;

  # Enable zsh
  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];

  # Set up the user account
  # services.getty.autologinUser = "toh995";
  users.users.toh995 = {
    name = "toh995";
    home = "/home/toh995";
    createHome = true;
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "obsidian"
    ];

  # Set up sudo
  security.sudo = {
    enable = true;
    package = pkgs.sudo.override {withInsults = true;};
    extraConfig = ''
      # Reference: https://wiki.archlinux.org/title/sudo#Disable_password_prompt_timeout
      Defaults passwd_timeout=0

      # Reference: https://wiki.archlinux.org/title/sudo#Reduce_the_number_of_times_you_have_to_type_a_password
      Defaults timestamp_timeout=30
    '';
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/systemctl suspend";
            options = ["NOPASSWD"];
          }
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = ["NOPASSWD"];
          }
          {
            command = "${pkgs.systemd}/bin/poweroff";
            options = ["NOPASSWD"];
          }
        ];
        groups = ["wheel"];
      }
    ];
  };
}
