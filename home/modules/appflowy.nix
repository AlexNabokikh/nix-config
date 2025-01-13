{
  lib,
  pkgs,
  ...
}: {
  # Ensure krew package installed
  home.packages = with pkgs; [
    appflowy
  ];

  # https://github.com/AppFlowy-IO/AppFlowy/issues/6105#issuecomment-2317462095
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "x-scheme-handler/appflowy-flutter" = ["appflowy-flutter.desktop"];
    };
    defaultApplications = {
      "x-scheme-handler/appflowy-flutter" = ["appflowy-flutter.desktop"];
    };
  };

  xdg.desktopEntries = {
    appflowy-flutter = {
      name = "Appflowy Flutter";
      exec = "${lib.getExe pkgs.appflowy} %U";
      terminal = false;
      categories = ["Application"];
      mimeType = ["x-scheme-handler/appflowy-flutter"];
    };
  };
}
