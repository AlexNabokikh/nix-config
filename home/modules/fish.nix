# Module: Fish Shell
# Purpose: Provides a dedicated Fish shell entrypoint for VS Code/Cursor
# Platform: All
{pkgs, ...}: {
  programs.fish = {
    enable = true;
    shellInit = "set fish_greeting ''";
  };

  programs.starship.enableFishIntegration = true;
  programs.fzf.enableFishIntegration = true;
  programs.atuin.enableFishIntegration = true;
  programs.zoxide.enableFishIntegration = true;

  home.packages = [
    (pkgs.writeShellScriptBin "vscode-fish" ''
      exec ${pkgs.fish}/bin/fish --login "$@"
    '')
  ];
}
