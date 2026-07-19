{pkgs, ...}: {
  home.sessionVariables = {
    ROCQPATH = "${pkgs.rocqPackages.stdlib}/lib/coq/${pkgs.rocqPackages.rocq-core.rocq-version}/user-contrib";
  };
}
