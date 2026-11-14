{ lib, ... }:
{
  stylix.targets.opencode.enable = true;

  programs.opencode = {
    enable = true;
    mutableSettings = true;
    # The pinned Stylix target generates the theme but selects it via V1's tui.json.
    tui = lib.mkForce { };
    cli.theme = {
      name = "stylix";
      mode = "dark";
    };
  };
}
