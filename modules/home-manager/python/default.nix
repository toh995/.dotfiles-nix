{ config, ... }:

{
  home.sessionVariables = {
    # Ensure that python will execute the correct file,
    # when first opening up a python REPL
    PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonstartup.py";
  };

  xdg.configFile."python/pythonstartup.py".source = ./pythonstartup.py;
}
