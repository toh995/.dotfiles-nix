{
  config,
  pkgs,
  ...
}: {
  # Set up dark theme
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
      # package = pkgs.materia-kde-theme;
      # name = "Materia-dark-compact";
      # package = pkgs.breeze-gtk;
      # name = "Breeze-dark";
    };
  };
  # Try this, if we ever install a QT application...
  # qt = {
  #   enable = true;
  #   style = {
  #     package = pkgs.adwaita-qt;
  #     name = "adwaita-dark";
  #   };
  # };
}
