{config, ...}: {
  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
  };

  xdg.configFile."npm/npmrc".source = ./npmrc;
}
