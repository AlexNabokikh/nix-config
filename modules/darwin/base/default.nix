{ config, ... }:
let
  darwin = config.flake.modules.darwin;
in
{
  imports = [
    ./nix.nix
    ./users.nix
    ./sudo.nix
    ./defaults-system.nix
    ./defaults-apps.nix
    ./keyboard.nix
    ./fonts.nix
  ];

  flake.modules.darwin.base = {
    imports = [
      darwin.nix
      darwin.users
      darwin.sudo
      darwin.defaultsSystem
      darwin.defaultsApps
      darwin.keyboard
      darwin.fonts
    ];
  };
}
