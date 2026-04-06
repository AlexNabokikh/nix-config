{ config, ... }:
{
  flake.modules.nixos.users =
    moduleArgs@{
      lib,
      pkgs,
      ...
    }:
    {
      options.primaryUser = lib.mkOption {
        type = lib.types.str;
        description = "Primary username for this system";
      };

      config = {
        users.users.${moduleArgs.config.primaryUser} = {
          description = config.profile.fullName;
          extraGroups = [
            "networkmanager"
            "video"
            "wheel"
          ];
          isNormalUser = true;
          shell = pkgs.zsh;
        };

        system.activationScripts.setUserAvatar.text = ''
          mkdir -p /var/lib/AccountsService/{icons,users}
          cp ${config.profile.avatar} /var/lib/AccountsService/icons/${moduleArgs.config.primaryUser}

          touch /var/lib/AccountsService/users/${moduleArgs.config.primaryUser}

          if ! grep -q "^Icon=" /var/lib/AccountsService/users/${moduleArgs.config.primaryUser}; then
            if ! grep -q "^\[User\]" /var/lib/AccountsService/users/${moduleArgs.config.primaryUser}; then
              echo "[User]" >> /var/lib/AccountsService/users/${moduleArgs.config.primaryUser}
            fi
            echo "Icon=/var/lib/AccountsService/icons/${moduleArgs.config.primaryUser}" >> /var/lib/AccountsService/users/${moduleArgs.config.primaryUser}
          fi
        '';

        security.sudo.wheelNeedsPassword = false;
        programs.zsh.enable = true;
      };
    };
}
