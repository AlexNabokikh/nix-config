{ ... }:
{
  flake.modules.generic.profile =
    {
      lib,
      pkgs,
      ...
    }:
    {
      options.profile = lib.mkOption {
        type = lib.types.raw;
        readOnly = true;
      };

      config.profile = {
        email = "alexander.nabokikh@olx.pl";
        fullName = "Alexander Nabokikh";
        gitKey = "C5810093";
        avatar = ./avatar;
        wallpaper = ./wallpaper.jpg;

        appearance = {
          catppuccin = {
            flavor = "mocha";
            accent = "lavender";
          };

          iconTheme = {
            name = "Tela-circle-dark";
            package = pkgs.tela-circle-icon-theme;
          };

          cursorTheme = {
            name = "Yaru";
            package = pkgs.yaru-theme;
            size = 24;
          };

          fonts = {
            ui = {
              family = "Roboto";
              size = 11;
              package = pkgs.roboto;
            };

            monospace = {
              family = "JetBrainsMono Nerd Font Mono";
              package = pkgs.nerd-fonts.jetbrains-mono;
            };

            terminal = {
              family = "MesloLGS Nerd Font";
              package = pkgs.nerd-fonts.meslo-lg;
              size = {
                linux = 12;
                darwin = 15;
              };
            };
          };
        };

        locale = {
          timezone = "Europe/Warsaw";
          default = "en_US.UTF-8";
          extra = {
            LC_ADDRESS = "en_IE.UTF-8";
            LC_IDENTIFICATION = "en_IE.UTF-8";
            LC_MEASUREMENT = "en_IE.UTF-8";
            LC_MONETARY = "en_IE.UTF-8";
            LC_NAME = "en_IE.UTF-8";
            LC_NUMERIC = "en_IE.UTF-8";
            LC_PAPER = "en_IE.UTF-8";
            LC_TELEPHONE = "en_IE.UTF-8";
            LC_TIME = "en_IE.UTF-8";
          };
        };
      };
    };
}
