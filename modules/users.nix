{ lib, ... }:
{
  options.userInfo = lib.mkOption {
    type = lib.types.submodule {
      options = {
        email = lib.mkOption { type = lib.types.str; };
        fullName = lib.mkOption { type = lib.types.str; };
        gitKey = lib.mkOption { type = lib.types.str; };
        avatar = lib.mkOption { type = lib.types.path; };
        wallpaper = lib.mkOption { type = lib.types.path; };
      };
    };
  };

  config.userInfo = {
    email = "alexander.nabokikh@olx.pl";
    fullName = "Alexander Nabokikh";
    gitKey = "C5810093";
    avatar = ../files/avatar;
    wallpaper = ../files/wallpaper.jpg;
  };
}
