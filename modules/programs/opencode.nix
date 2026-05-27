{
  flake.modules.homeManager.opencode = {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
    };
  };
}
