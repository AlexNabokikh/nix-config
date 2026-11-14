{ config, lib, ... }:
{
  options.terminalFont = {
    family = lib.mkOption {
      type = lib.types.str;
      description = "Monospace font family used in the terminal.";
    };
    package = lib.mkOption {
      type = lib.types.package;
      description = "Package providing the terminal font.";
    };
    size = {
      linux = lib.mkOption {
        type = lib.types.number;
        description = "Terminal font size on Linux.";
      };
      darwin = lib.mkOption {
        type = lib.types.number;
        description = "Terminal font size on macOS.";
      };
    };
  };

  # Only the terminal font is managed; everything else uses the desktop's defaults.
  config.fonts.packages = [ config.terminalFont.package ];
}
