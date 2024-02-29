{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    dotDir = ".config/zsh";
    history.path = "${config.xdg.stateHome}/zsh/.zsh_history";

    # home-manager will generate a read-only .zshrc.
    # Here we append some custom stuff to the generated .zshrc
    initExtra = builtins.readFile ./.zshrc;

    # enable powerlevel10k
    plugins = [
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
