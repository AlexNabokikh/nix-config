{
  flake.modules.homeManager.aws = {
    programs.awscli.enable = true;
    programs.granted.enable = true;
  };
}
