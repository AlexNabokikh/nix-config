{
  flake.modules.homeManager.bat =
    { config, lib, ... }:
    {
      catppuccin.bat.enable = false;

      programs.bat = {
        enable = true;
        config.theme = "Catppuccin ${lib.toSentenceCase config.profile.appearance.catppuccin.flavor}";
      };

      home.activation.batCache = lib.mkForce (lib.hm.dag.entryAnywhere "");
    };
}
