{
  flake.modules.homeManager.xdg = {
    xdg.enable = true;
  };

  flake.modules.homeManager.xdgUserDirs = {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
