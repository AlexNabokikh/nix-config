{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../common/base.nix
    ./aerospace.nix
    ./keyboard.nix
    ./system-preferences.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  programs.zsh.enableBashCompletion = false;

  users.users.${config.user.name} = {
    home = "/Users/${config.user.name}";
  };

  security.sudo.extraConfig = ''
    ${config.user.name}    ALL = (ALL) NOPASSWD: ALL
  '';

  system.primaryUser = config.user.name;
}
