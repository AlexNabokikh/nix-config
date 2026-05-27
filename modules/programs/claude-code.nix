{
  flake.modules.homeManager.claudeCode = {
    programs.claude-code = {
      enable = true;
      enableMcpIntegration = true;
    };
  };
}
