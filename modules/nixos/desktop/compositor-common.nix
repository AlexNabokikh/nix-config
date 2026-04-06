{ ... }:
{
  flake.modules.nixos.desktopCompositorBase =
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
        loupe
        nautilus
        seahorse
        showtime
        gpu-screen-recorder
        grim
        libnotify
        pamixer
        pavucontrol
        slurp
      ];
    };
}
