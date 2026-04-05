{ ... }:
{
  flake.modules.homeManager.programsBtop =
    { ... }:
    {
      # Install btop via home-manager module
      programs.btop = {
        enable = true;
        settings = {
          vim_keys = true;
          proc_sorting = "memory";
        };
      };
    };
}
