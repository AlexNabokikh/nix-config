{
  flake.modules.homeManager.programsBtop = {
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
        proc_sorting = "memory";
      };
    };
  };
}
