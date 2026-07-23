{
  flake.modules.darwin.brave = {
    system.defaults.CustomUserPreferences."com.brave.Browser".NSUserKeyEquivalents = {
      "Actual Size" = "^0";
      "Close Tab" = "^w";
      "Find..." = "^f";
      "New Private Window" = "^$n";
      "New Tab" = "^t";
      "Reload This Page" = "^r";
      "Reopen Closed Tab" = "^$t";
      "Zoom In" = "^=";
      "Zoom Out" = "^-";
    };
  };

  flake.modules.homeManager.brave = {
    programs.brave.enable = true;
  };
}
