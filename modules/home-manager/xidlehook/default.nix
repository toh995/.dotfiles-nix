{pkgs, ...}: {
  # Auto-suspend after 30 min idle, unless audio is playing.
  # Warns 60s beforehand; any input cancels.
  services.xidlehook = {
    enable = true;
    not-when-audio = true;
    timers = [
      {
        delay = 7200;
        command = "${pkgs.libnotify}/bin/notify-send -u critical -t 60000 'Suspending in 60 seconds' 'Move the mouse to cancel'";
        canceller = "${pkgs.dunst}/bin/dunstctl close-all";
      }
      {
        delay = 60;
        command = "systemctl suspend";
      }
    ];
  };
}
