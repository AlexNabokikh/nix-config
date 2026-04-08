{ ... }:
{
  flake.modules.nixos.desktopCompositorCommon =
    { pkgs, ... }:
    {
      services.displayManager.gdm.enable = true;
      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;
      services.gnome.gnome-keyring.enable = true;
      security.polkit.enable = true;
      security.pam.services.gdm.enableGnomeKeyring = true;

      environment.systemPackages = with pkgs; [
        file-roller
        gnome-calculator
        gnome-pomodoro
        gnome-text-editor
        gpu-screen-recorder
        grim
        libnotify
        loupe
        nautilus
        pamixer
        pavucontrol
        seahorse
        showtime
        slurp
      ];
    };
}
