{
  flake.modules.nixos.desktopApps = {
    services.gvfs.enable = true;
  };

  flake.modules.homeManager.desktopApps =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        file-roller
        gnome-calculator
        gnome-text-editor
        loupe
        nautilus
        pavucontrol
        seahorse
        showtime
      ];

      dconf.settings."org/gnome/nautilus/preferences".default-folder-viewer = "list-view";

      xdg.mimeApps = {
        enable = true;
        defaultApplicationPackages = [
          pkgs.file-roller
          pkgs.gnome-text-editor
          pkgs.loupe
          pkgs.nautilus
          pkgs.showtime
        ];
      };
    };
}
