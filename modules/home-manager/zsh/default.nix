{ config, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    dotDir = ".config/zsh";
    history.path = "${config.xdg.stateHome}/zsh/.zsh_history";

    # home-manager will generate a read-only .zshrc.
    # Here we append some custom stuff to the generated .zshrc
    initExtra = builtins.readFile ./.zshrc;
  };
}
