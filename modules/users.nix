{
  flake.modules.nixos.users =
    { config, pkgs, ... }:
    {
      users.users.${config.primaryUser} = {
        description = config.profile.fullName;
        extraGroups = [
          "networkmanager"
          "video"
          "wheel"
        ];
        isNormalUser = true;
      };

      system.activationScripts.setUserAvatar.text = ''
        mkdir -p /var/lib/AccountsService/{icons,users}
        install -m644 ${config.profile.avatar} "/var/lib/AccountsService/icons/${config.primaryUser}"

        touch "/var/lib/AccountsService/users/${config.primaryUser}"
        ${pkgs.crudini}/bin/crudini --set \
          "/var/lib/AccountsService/users/${config.primaryUser}" \
          User Icon "/var/lib/AccountsService/icons/${config.primaryUser}"
      '';

      security.sudo.wheelNeedsPassword = false;
    };

  flake.modules.darwin.users =
    { config, ... }:
    {
      users.users.${config.primaryUser} = {
        home = "/Users/${config.primaryUser}";
      };

      system.primaryUser = config.primaryUser;
    };
}
