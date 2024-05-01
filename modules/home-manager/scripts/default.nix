{pkgs, ...}: let
  t = pkgs.writeShellScriptBin "t" (builtins.readFile ./t);
  git-remote-rclone = pkgs.writeShellScriptBin "git-remote-rclone" (builtins.readFile ./git-remote-rclone);
in {
  home.packages = [git-remote-rclone t];
}
