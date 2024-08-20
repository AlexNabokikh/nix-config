{...}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    userName = "Alexander Nabokikh";
    userEmail = "alexander.nabokikh@olx.pl";
    signing = {
      key = "C5810093";
      signByDefault = true;
    };
    delta = {
      enable = true;
      catppuccin.enable = true;
      options = {
        keep-plus-minus-markers = true;
        light = false;
        line-numbers = true;
        navigate = true;
        width = 280;
      };
    };
    extraConfig = {
      pull.rebase = "true";
    };
  };
}
