{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.desktopCompositorCommon =
    { pkgs, ... }:
    {
      imports = [
        hm.desktopCursor
        hm.desktopDconf
        hm.desktopGtk
        hm.desktopQt
        hm.desktopXdg
        hm.programsNoctalia
        hm.programsSwappy
        hm.servicesHypridle
      ];

      home.packages = with pkgs; [
        file-roller
        gnome-calculator
        gnome-pomodoro
        gnome-text-editor
        gpu-screen-recorder
        grim
        libnotify
        loupe
        nautilus
        pavucontrol
        seahorse
        showtime
        slurp
      ];
    };
}
