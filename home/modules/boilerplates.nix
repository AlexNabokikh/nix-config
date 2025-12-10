# Module: Boilerplates
# Purpose: Provides project scaffolding and template generation tools
# Platform: All
{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.boilerplates.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
