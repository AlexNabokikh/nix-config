# Module: Fuelcheck CLI
# Purpose: Configures Fuelcheck CLI for AI token usage monitoring
# Platform: All
{
  home.sessionVariables = {
    # Makes fuelcheck available via nix run github:chasebuild/fuelcheck-cli
  };

  home.shellAliases = {
    fuelcheck = "nix run github:chasebuild/fuelcheck-cli --";
    fuelcheck-setup = "nix run github:chasebuild/fuelcheck-cli -- setup";
  };
}
