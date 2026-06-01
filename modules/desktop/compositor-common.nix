{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.nixos.compositorCommon =
    { config, pkgs, ... }:
    {
      services = {
        displayManager.gdm.enable = true;
        power-profiles-daemon.enable = true;
        upower.enable = true;
        gnome.gnome-keyring.enable = true;
      };

      environment.sessionVariables.XDG_DATA_DIRS = [ "${pkgs.gdm}/share" ];

      security = {
        polkit.enable = true;
        pam.services = {
          # FIXME: Temporary workaround for nixpkgs#523332
          gdm.enableGnomeKeyring = true;
          gdm-launch-environment.rules.session.gnome-session-path = {
            order = config.security.pam.services.gdm-launch-environment.rules.session.systemd.order + 50;
            control = "required";
            modulePath = "${config.security.pam.package}/lib/security/pam_env.so";

            settings = {
              conffile =
                let
                  env = config.services.displayManager.generic.environment;
                in
                pkgs.writeText "gdm-launch-environment-env-conf" ''
                  PATH                    DEFAULT="''${PATH}:${pkgs.gnome-session}/bin"
                  XDG_DATA_DIRS           DEFAULT="''${XDG_DATA_DIRS}:${env.XDG_DATA_DIRS}"
                  GDM_X_SERVER_EXTRA_ARGS DEFAULT="${env.GDM_X_SERVER_EXTRA_ARGS}"
                '';
              readenv = 0;
            };
          };
        };
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
