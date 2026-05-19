{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.nixos.compositorCommon = {
    services = {
      displayManager.gdm.enable = true;
      power-profiles-daemon.enable = true;
      upower.enable = true;
      gnome.gnome-keyring.enable = true;
    };

    security = {
      polkit.enable = true;
      pam.services.gdm.enableGnomeKeyring = true;
    };
  };

  flake.modules.homeManager.compositorCommon =
    { pkgs, ... }:
    {
      imports = [
        hm.cursor
        hm.dconf
        hm.gtk
        hm.qt
        hm.xdg
        hm.noctalia
        hm.swappy
        hm.idle
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
