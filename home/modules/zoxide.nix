# Module: Zoxide
# Purpose: Configures zoxide for smarter cd command
# Platform: All
_: {
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
