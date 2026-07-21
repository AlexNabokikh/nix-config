{
  flake.modules.darwin.mos = {
    system.defaults.CustomUserPreferences."com.caldis.Mos".hideStatusItem = true;
  };

  flake.modules.homeManager.mos =
    { lib, pkgs, ... }:
    {
      home.packages = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.mos ];
    };
}
