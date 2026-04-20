{
  flake.modules.homeManager.desktopAerospace = {
    programs.aerospace = {
      enable = true;
      launchd.enable = true;
      settings = fromTOML (builtins.readFile ./aerospace.toml);
    };
  };
}
