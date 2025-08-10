{ ... }:
{
  xdg = {
    enable = true;

    mimeApps = {
      enable = true;

      associations.added = {
        "audio/mpeg" = [ "org.gnome.Totem.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "video/mp4" = [ "org.gnome.Totem.desktop" ];
        "video/quicktime" = [ "org.gnome.Totem.desktop" ];
        "video/webm" = [ "org.gnome.Totem.desktop" ];
      };

      defaultApplications = {
        "application/json" = [ "org.gnome.TextEditor.desktop" ];
        "application/toml" = [ "org.gnome.TextEditor.desktop" ];
        "application/x-gnome-saved-search" = [ "org.gnome.Nautilus.desktop" ];
        "audio/mpeg" = [ "org.gnome.Totem.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "text/plain" = [ "org.gnome.TextEditor.desktop" ];
        "video/mp4" = [ "org.gnome.Totem.desktop" ];
      };
    };

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
