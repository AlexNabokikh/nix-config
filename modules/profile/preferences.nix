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
        readOnly = true;
        type = lib.types.submodule {
          options = {
            email = lib.mkOption { type = lib.types.str; };
            fullName = lib.mkOption { type = lib.types.str; };
            gitKey = lib.mkOption { type = lib.types.str; };
            avatar = lib.mkOption { type = lib.types.path; };
            wallpaper = lib.mkOption { type = lib.types.path; };

            appearance = lib.mkOption {
              type = lib.types.submodule {
                options = {
                  catppuccin = lib.mkOption {
                    type = lib.types.submodule {
                      options = {
                        flavor = lib.mkOption { type = lib.types.str; };
                        accent = lib.mkOption { type = lib.types.str; };
                      };
                    };
                  };

                  iconTheme = lib.mkOption {
                    type = lib.types.submodule {
                      options = {
                        name = lib.mkOption { type = lib.types.str; };
                        package = lib.mkOption { type = lib.types.package; };
                      };
                    };
                  };

                  cursorTheme = lib.mkOption {
                    type = lib.types.submodule {
                      options = {
                        name = lib.mkOption { type = lib.types.str; };
                        package = lib.mkOption { type = lib.types.package; };
                        size = lib.mkOption { type = lib.types.int; };
                      };
                    };
                  };

                  fonts = lib.mkOption {
                    type = lib.types.submodule {
                      options = {
                        ui = lib.mkOption {
                          type = lib.types.submodule {
                            options = {
                              family = lib.mkOption { type = lib.types.str; };
                              size = lib.mkOption { type = lib.types.int; };
                              package = lib.mkOption { type = lib.types.package; };
                            };
                          };
                        };

                        monospace = lib.mkOption {
                          type = lib.types.submodule {
                            options = {
                              family = lib.mkOption { type = lib.types.str; };
                              package = lib.mkOption { type = lib.types.package; };
                            };
                          };
                        };

                        terminal = lib.mkOption {
                          type = lib.types.submodule {
                            options = {
                              family = lib.mkOption { type = lib.types.str; };
                              package = lib.mkOption { type = lib.types.package; };
                              size = lib.mkOption {
                                type = lib.types.submodule {
                                  options = {
                                    linux = lib.mkOption { type = lib.types.int; };
                                    darwin = lib.mkOption { type = lib.types.int; };
                                  };
                                };
                              };
                            };
                          };
                        };
                      };
                    };
                  };
                };
              };
            };

            locale = lib.mkOption {
              type = lib.types.submodule {
                options = {
                  timezone = lib.mkOption { type = lib.types.str; };
                  default = lib.mkOption { type = lib.types.str; };
                  extra = lib.mkOption { type = lib.types.attrsOf lib.types.str; };
                };
              };
            };
          };
        };
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
