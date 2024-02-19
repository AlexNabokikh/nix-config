{...}: let
  wallpaper = ./../../files/wallpapers/wallpaper.jpg;
  hyprland = ./../../files/configs/hypr;
in {
  imports = [
    ./clipboard.nix
    ./gtklock.nix
    ./kanshi.nix
    ./swaync.nix
    ./waybar.nix
    ./wofi.nix
    ./xdg.nix
  ];
  # Source hyprland config from the home-manager store
  home.file = {
    ".config/hypr" = {
      recursive = true;
      source = "${hyprland}";
    };
    ".config/hypr/hyprpaper.conf".text = ''
      splash = false
      preload = ${wallpaper}
      wallpaper = DP-1, ${wallpaper}
      wallpaper = eDP-1, ${wallpaper}
    '';
  };
}
