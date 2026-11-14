{ inputs, ... }:
{
  imports = [ inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = false;
    polarity = "dark";
    base16Scheme = "${inputs.stylix.inputs.tinted-schemes}/base16/catppuccin-mocha.yaml";

    # Adwaita's dark surfaces with Catppuccin Mocha's accents.
    override = {
      base00 = "1d1d20";
      base01 = "222226";
      base02 = "2e2e32";
      base03 = "6c6c70";
    };
  };
}
