{
  pkgs,
  lib,
  ...
}: let
  krewPkgs = [
    "ctx"
    "get-all"
    "ns"
    "stern"
  ];
in {
  # Ensure krew package installed
  home.packages = with pkgs; [
    krew
  ];

  # Adding krew to a session PATH
  home.sessionPath = [
    "$HOME/.krew/bin"
  ];

  # Install krew plugins
  home.activation.krew = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH="$PATH:${pkgs.git}/bin/:/usr/bin/";
    export PATH="$PATH:$HOME/.krew/bin";
    ${pkgs.krew}/bin/krew install ${builtins.toString krewPkgs}
    ${pkgs.krew}/bin/krew upgrade
  '';
}
