{
  flake.modules.homeManager.mcp = {
    programs.mcp = {
      enable = true;
      servers."Nix MCP" = {
        command = "nix";
        args = [
          "run"
          "github:utensils/mcp-nixos"
          "--"
        ];
      };
    };
  };
}
