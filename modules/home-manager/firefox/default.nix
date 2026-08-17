{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.firefox.enable = true;

  # If home.stateVersion < 26.05 (like we are), then config will be saved to
  # `~/.mozilla/firefox`. This causes a warning during nixos reubuilds.
  # For later state versions, we use the XDG config by default
  # (i.e. `~/.config/mozilla/firefox`).
  # We can silence the warning, by explicitly opting in to the new config file location.
  programs.firefox.configPath = "${lib.removePrefix "${config.home.homeDirectory}/" config.xdg.configHome}/mozilla/firefox";

  programs.firefox.profiles.toh995 = {
    isDefault = true;
    id = 0;
    search.default = "google";
    extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      vimium
    ];
  };
}
