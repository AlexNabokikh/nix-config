{ config, ... }:
{
  users.users.${config.user.name} = {
    description = "Alexander Nabokikh";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    shell = config.programs.zsh.package;
  };

  security.sudo.wheelNeedsPassword = false;
}
