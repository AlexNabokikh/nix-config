{
  flake.modules.homeManager.aws = {
    programs.awscli.enable = true;
    programs.granted.enable = true;

    programs.starship.settings.aws.disabled = true;
  };
}
