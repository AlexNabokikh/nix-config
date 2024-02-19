{...}: {
  # Install wofi via home-manager module
  programs.wofi = {
    enable = true;
    settings = {
      normal_window = true;
      prompt = "";
      width = "50%";
      height = "40%";
      key_up = "Ctrl+k";
      key_down = "Ctrl+j";
    };
  };
}
