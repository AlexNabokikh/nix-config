{ config, ... }:
{
  programs.zsh.enableGlobalCompInit = false;

  users.users.${config.user.name} = {
    home = "/Users/${config.user.name}";
  };

  security.sudo.extraConfig = ''
    ${config.user.name}    ALL = (ALL) NOPASSWD: ALL
  '';

  system.primaryUser = config.user.name;
}
