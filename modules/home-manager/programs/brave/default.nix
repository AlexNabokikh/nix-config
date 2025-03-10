{
  pkgs,
  lib,
  ...
}: {
  # Ensure Brave browser package installed
  home.packages = with pkgs; [
    brave
  ];

  # Apply XDG configuration only on non-Darwin platforms
  xdg = lib.mkIf (!pkgs.stdenv.isDarwin) {
    mimeApps = {
      defaultApplications = {
        "application/x-extension-htm" = "brave-browser.desktop";
        "application/x-extension-html" = "brave-browser.desktop";
        "application/x-extension-shtml" = "brave-browser.desktop";
        "application/x-extension-xht" = "brave-browser.desktop";
        "application/x-extension-xhtml" = "brave-browser.desktop";
        "application/xhtml+xml" = "brave-browser.desktop";
        "text/html" = "brave-browser.desktop";
        "x-scheme-handler/about" = "brave-browser.desktop";
        "x-scheme-handler/chrome" = ["chromium-browser.desktop"];
        "x-scheme-handler/ftp" = "brave-browser.desktop";
        "x-scheme-handler/http" = "brave-browser.desktop";
        "x-scheme-handler/https" = "brave-browser.desktop";
        "x-scheme-handler/unknown" = "brave-browser.desktop";
        "application/pdf" = "brave-browser.desktop";
      };
    };
  };
}
