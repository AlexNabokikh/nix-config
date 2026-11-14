{ config, ... }:
{
  programs.go.enable = true;

  home.sessionPath = [ "${config.home.homeDirectory}/go/bin" ];
}
