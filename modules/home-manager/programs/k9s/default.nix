{...}: {
  # Install k9s via home-manager module
  programs.k9s = {
    enable = true;
    settings.k9s = {
      ui = {
        headless = true;
        logoless = true;
      };
    };
    hotkey.hotKeys = {
      shift-1 = {
        shortCut = "Shift-1";
        description = "Show pods";
        command = "pods";
      };
      shift-2 = {
        shortCut = "Shift-2";
        description = "Show deployments";
        command = "dp";
      };
      shift-3 = {
        shortCut = "Shift-3";
        description = "Show nodes";
        command = "nodes";
      };
      shift-4 = {
        shortCut = "Shift-4";
        description = "Show services";
        command = "services";
      };
      shift-5 = {
        shortCut = "Shift-5";
        description = "Show Ingress";
        command = "ingress";
      };
    };
  };

  # Enable catppuccin theming for k9s
  catppuccin.k9s.enable = true;
}
