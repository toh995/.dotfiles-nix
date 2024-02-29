{config, ...}: let
  home = config.home.homeDirectory;
in {
  xdg = {
    enable = true;

    cacheHome = "${home}/.cache";
    configHome = "${home}/.config";
    dataHome = "${home}/.local/share";
    stateHome = "${home}/.local/state";

    systemDirs = {
      config = ["/etc/xdg"];
      data = ["/usr/share" "/usr/local/share"];
    };
  };
}
