{ config, ... }:
{
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };

  users.users.${config.user.name} = {
    description = config.user.fullName;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    shell = config.programs.zsh.package;
  };

  security.sudo.wheelNeedsPassword = false;
}
