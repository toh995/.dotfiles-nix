{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    dotDir = ".config/zsh";
    history.path = "${config.xdg.stateHome}/zsh/.zsh_history";

    # home-manager will generate a read-only .zshrc.
    # Here we append some custom stuff to the generated .zshrc
    initExtra = builtins.readFile ./.zshrc;

    plugins = [
      # vi mode
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      # powerlevel10k
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./powerlevel10k-config;
        file = "p10k.zsh";
      }
    ];
  };
}
