{ config, ... }:
let
  GOPATH = "${config.home.homeDirectory}/go";
  GOBIN = "${GOPATH}/bin";
in
{
  # Install and configure Golang via home-manager module
  programs.go = {
    enable = true;
    env = { inherit GOBIN GOPATH; };
  };

  # Ensure Go bin in the PATH
  home.sessionPath = [
    "$HOME/go/bin"
  ];
}
