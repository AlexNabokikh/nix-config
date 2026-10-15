{
  flake.modules.homeManager.atuin =
    { pkgs, ... }:
    {
      programs.atuin = {
        enable = true;
        # Temporary workaround for https://github.com/NixOS/nixpkgs/issues/573527.
        # Remove once the fixed nixpkgs revision is included in flake.lock.
        package =
          if pkgs.stdenv.hostPlatform.isDarwin then
            pkgs.atuin.overrideAttrs (_: {
              doCheck = false;
            })
          else
            pkgs.atuin;
        settings = {
          inline_height = 25;
          invert = true;
          search_mode = "fuzzy";
        };
        flags = [ "--disable-up-arrow" ];
      };
    };
}
