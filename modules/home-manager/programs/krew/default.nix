{
  pkgs,
  lib,
  ...
}: let
  krewPkgs = [
    "ctx"
    "get-all"
    "ns"
    "rbac-lookup"
    "stern"
  ];

  # Convert the list of plugins into a space-separated string
  krewPkgStr = lib.concatStringsSep " " krewPkgs;
in {
  # Ensure krew package installed
  home.packages = with pkgs; [
    krew
  ];

  # Ensure krew is in the PATH
  home.sessionPath = [
    "$HOME/.krew/bin"
  ];

  # Install krew plugins
  home.activation.krew = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH="$HOME/.krew/bin:${pkgs.git}/bin:/usr/bin:$PATH";

    if [ -z "$(${pkgs.krew}/bin/krew list)" ]; then
      ${pkgs.krew}/bin/krew install ${krewPkgStr}
    else
      ${pkgs.krew}/bin/krew upgrade
    fi
  '';
}
