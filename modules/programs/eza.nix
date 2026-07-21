{
  flake.modules.homeManager.eza = {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      extraOptions = [ "--group-directories-first" ];
    };
  };
}
