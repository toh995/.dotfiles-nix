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

      # GUI programs
      alacritty
      brave
      kitty # todo: switch out kitty

      # CLI programs
      btop
      # delta
      git
      lazydocker
      lazygit
      mpv
      neofetch
      neovim
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

    # git config
    programs.git = {
      enable = true;
      userName = "toh995";
      userEmail = "52012721+toh995@users.noreply.github.com";
    };
  };
}
