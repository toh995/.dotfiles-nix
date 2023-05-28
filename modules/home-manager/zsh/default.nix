{ config, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    dotDir = ".config/zsh";
    history.path = "${config.xdg.stateHome}/zsh/.zsh_history";
  };
}
