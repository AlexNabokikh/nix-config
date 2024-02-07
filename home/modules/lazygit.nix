{...}: {
  # Install lazygit via home-manager module
  programs.lazygit = {
    enable = true;

    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta";
        };
      };
    };
  };
}
