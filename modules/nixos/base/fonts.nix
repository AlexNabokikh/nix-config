{ config, ... }:
{
  flake.modules.nixos.fonts =
    {
      lib,
      pkgs,
      ...
    }:
    let
      resolvePackage =
        packagePath:
        lib.attrByPath packagePath
          (throw "Profile font package path not found: ${lib.concatStringsSep "." packagePath}")
          pkgs;
      fontPackagePaths = lib.unique [
        config.profile.appearance.fonts.ui.packagePath
        config.profile.appearance.fonts.monospace.packagePath
        config.profile.appearance.fonts.terminal.packagePath
      ];
    in
    {
      fonts.packages = builtins.map resolvePackage fontPackagePaths;
    };
}
