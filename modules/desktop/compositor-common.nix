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

      # "Quit All Applications" desktop entry helper
      _module.args.mkQuitAllEntry = pipeline: {
        name = "Quit All Applications";
        icon = "system-log-out";
        exec = ''${pkgs.bash}/bin/bash -lc "${pipeline}"'';
      };

      home.packages = with pkgs; [
        file-roller
        gnome-calculator
        gnome-pomodoro
        gnome-text-editor
        gpu-screen-recorder
        grim
        hyprpicker
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
