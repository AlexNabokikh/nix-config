{
  pkgs,
  lib,
  ...
}: {
  # Ensure Telegram desktop package installed
  home.packages = with pkgs; [
    telegram-desktop
  ];

  # XDG configuration (only on non-Darwin platforms)
  xdg = lib.mkIf (!pkgs.stdenv.isDarwin) {
    mimeApps = {
      associations.added = {
        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
        "x-scheme-handler/tonsite" = ["org.telegram.desktop.desktop"];
      };
      defaultApplications = {
        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
        "x-scheme-handler/tonsite" = ["org.telegram.desktop.desktop"];
      };
    };
  };
}
