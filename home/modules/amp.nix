# Module: Amp CLI
# Purpose: AI-powered coding agent from Sourcegraph
# Platform: All
{pkgs, ...}: {
  home.packages = with pkgs; [
    amp-cli
  ];
}
