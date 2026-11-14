{ pkgs, ... }:
let
  scripts = pkgs.runCommand "personal-scripts" { } ''
    mkdir -p "$out/bin"
    install -m755 ${./bin}/* "$out/bin/"
  '';
in
{
  home.packages = [ scripts ];
}
