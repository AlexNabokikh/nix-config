# GNOME desktop (system side). The user session lives in ./session.nix.
{ lib, pkgs, ... }:
{
  home-manager.sharedModules = [ ./session.nix ];

  # Compile en_IE into glibc so GNOME's Formats setting (./session.nix) can use it.
  # The timezone is set imperatively in GNOME Settings / `timedatectl`, as on macOS.
  i18n.extraLocales = [ "en_IE.UTF-8/UTF-8" ];

  i18n.inputMethod.enable = false;

  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    dleyna.enable = false;
    geoclue2.enable = false;
    gnome = {
      evolution-data-server.enable = lib.mkForce false;
      gcr-ssh-agent.enable = false;
      gnome-browser-connector.enable = false;
      gnome-initial-setup.enable = false;
      gnome-online-accounts.enable = false;
      gnome-remote-desktop.enable = false;
      gnome-user-share.enable = false;
      localsearch.enable = false;
      rygel.enable = false;
      tinysparql.enable = false;
    };
  };

  programs.bash.vteIntegration = false;
  programs.zsh.vteIntegration = false;

  environment.gnome.excludePackages = with pkgs; [
    baobab
    decibels
    epiphany
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-connections
    gnome-console
    gnome-contacts
    gnome-disk-utility
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-system-monitor
    gnome-tecla
    gnome-tour
    gnome-weather
    papers
    simple-scan
    snapshot
    yelp
  ];
}
