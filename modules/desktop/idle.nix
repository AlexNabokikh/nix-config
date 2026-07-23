{
  flake.modules.homeManager.idle =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      niri = lib.getExe pkgs.niri;
      noctalia = lib.getExe config.programs.noctalia.package;
    in
    {
      services.swayidle = {
        enable = true;
        events = {
          "before-sleep" = "${noctalia} msg session lock";
          "after-resume" = "${niri} msg action power-on-monitors";
          lock = "${noctalia} msg session lock";
        };
      };
    };
}
