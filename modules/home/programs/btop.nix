{
  stylix.targets.btop.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      proc_sorting = "memory";
    };
  };
}
