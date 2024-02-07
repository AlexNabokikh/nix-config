{...}: {
  programs.lazygit = {
    enable = true;

    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --syntax-theme catppuccin --paging=never --line-numbers";
        };
      };
    };
  };
}
