{
  flake.modules.homeManager.fastfetch =
    { config, ... }:
    {
      programs.zsh.shellAliases.ff = "fastfetch --structure-disabled title";
      programs.fastfetch.enable = true;

      xdg.configFile."fastfetch/config.jsonc".source =
        "${config.programs.fastfetch.package}/share/fastfetch/presets/examples/12.jsonc";
    };
}
