{
  inputs,
  pkgs,
  catppuccin,
}:
let
  paletteFile = "${inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.palette}/palette.json";
  palette = builtins.fromJSON (builtins.readFile paletteFile);
  flavorPalette = palette.${catppuccin.flavor}.colors;
  color = name: flavorPalette.${name}.hex;
  accentColor = color catppuccin.accent;
in
{
  mPrimary = accentColor;
  mOnPrimary = color "crust";
  mSecondary = color "pink";
  mOnSecondary = color "crust";
  mTertiary = color "mauve";
  mOnTertiary = color "crust";
  mError = color "red";
  mOnError = color "crust";
  mSurface = color "base";
  mOnSurface = color "text";
  mSurfaceVariant = color "surface0";
  mOnSurfaceVariant = color "subtext0";
  mOutline = color "overlay0";
  mShadow = color "crust";
  mHover = accentColor;
  mOnHover = color "crust";
}
