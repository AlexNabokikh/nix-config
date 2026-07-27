{
  flake.modules.homeManager.eza = {
    catppuccin.eza.enable = false;

    programs.eza = {
      enable = true;
      extraOptions = [ "--group-directories-first" ];
    };
  };
}
