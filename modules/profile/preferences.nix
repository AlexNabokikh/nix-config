{
  flake.modules.generic.profile =
    {
      lib,
      pkgs,
      ...
    }:
    {
      options.profile = lib.mkOption {
        readOnly = true;
        type = lib.types.raw;
        description = "Personal settings shared across all hosts and both module classes.";
      };

      config.profile = {
        email = "alexander.nabokikh@olx.pl";
        fullName = "Alexander Nabokikh";
        gitKey = "C5810093";
        avatar = ./avatar.jpg;
        wallpaper = ./wallpaper.jpg;

        appearance = {
          catppuccin = {
            flavor = "mocha";
            accent = "lavender";
          };

          iconTheme = {
            name = "Colloid-Catppuccin-Dark";
            package = pkgs.colloid-icon-theme.override {
              schemeVariants = [ "catppuccin" ];
            };
          };

          cursorTheme = {
            name = "Adwaita";
            package = pkgs.adwaita-icon-theme;
            size = 24;
          };

          fonts = {
            ui = {
              family = "Inter";
              size = 11;
              package = pkgs.inter;
            };

            monospace = {
              family = "MesloLGS Nerd Font Mono";
              package = pkgs.nerd-fonts.meslo-lg;
              size = 11;
            };

            terminalSize = {
              linux = 12;
              darwin = 15;
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
