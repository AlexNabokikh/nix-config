{ config, ... }:
{
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };

  users.users.${config.user.name} = {
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    shell = config.programs.zsh.package;
  };

  security.sudo.wheelNeedsPassword = false;
}
