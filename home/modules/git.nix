{userConfig, ...}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    userName = userConfig.fullName;
    userEmail = userConfig.email;
    signing = {
      key = userConfig.gitKey;
      signByDefault = true;
    };
    delta = {
      enable = true;
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

  # Enable catppuccin theming for git delta
  catppuccin.delta.enable = true;
}
