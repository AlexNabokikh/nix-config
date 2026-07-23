{
  flake.modules.homeManager.xdg = {
    xdg = {
      enable = true;

      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };
  };
}
