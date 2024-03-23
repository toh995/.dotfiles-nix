{pkgs, ...}: let
  t = pkgs.writeShellScriptBin "t" (builtins.readFile ./t);
in {
  home.packages = [t];
}
