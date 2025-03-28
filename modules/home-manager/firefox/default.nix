{pkgs, ...}: {
  programs.firefox.enable = true;
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
