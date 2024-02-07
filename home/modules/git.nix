{...}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    userName = "Alexander Nabokikh";
    userEmail = "alexander.nabokikh@olx.pl";
    signing = {
      key = "CD172433";
      signByDefault = true;
    };
    delta = {
      enable = true;
      options = {
        keep-plus-minus-markers = true;
        light = false;
        line-numbers = true;
        navigate = true;
        syntax-theme = "catppuccin";
        width = 280;
      };
    };
  };
}
