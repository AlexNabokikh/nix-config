{...}: let
  wallpaper = ./../../files/wallpapers/wallpaper-lock.jpg;
in {
  # Source gtklock config from the home-manager store
  home.file = {
    ".config/gtklock/style.css".text = ''
      window {
        background-image: url("${wallpaper}");
        background-size: cover;
        background-repeat: no-repeat;
        background-position: center;
        background-color: black;
      }
    '';
  };
}
