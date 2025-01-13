{...}: {
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "audio/mpeg" = ["org.gnome.Totem.desktop"];
        "image/jpeg" = ["org.gnome.Loupe.desktop"];
        "image/jpg" = ["org.gnome.Loupe.desktop"];
        "image/png" = ["org.gnome.Loupe.desktop"];
        "video/mp3" = ["org.gnome.Totem.desktop"];
        "video/mp4" = ["org.gnome.Totem.desktop"];
        "video/quicktime" = ["org.gnome.Totem.desktop"];
        "video/webm" = ["org.gnome.Totem.desktop"];
      };
      defaultApplications = {
        "application/json" = ["gnome-text-editor.desktop"];
        "application/toml" = "org.gnome.TextEditor.desktop";
        "application/x-gnome-saved-search" = ["org.gnome.Nautilus.desktop"];
        "audio/*" = ["org.gnome.Totem.dekstop"];
        "audio/mp3" = ["org.gnome.Totem.dekstop"];
        "image/*" = ["org.gnome.loupe.desktop"];
        "image/jpg" = ["org.gnome.loupe.desktop"];
        "image/png" = ["org.gnome.loupe.desktop"];
        "text/plain" = "org.gnome.TextEditor.desktop";
        "video/*" = ["org.gnome.Totem.dekstop"];
        "video/mp4" = ["org.gnome.Totem.dekstop"];
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
