{...}: {
  # Install mako via home-manager module
  services.mako = {
    enable = true;
    backgroundColor = "#24273a";
    borderColor = "#8aadf4";
    borderRadius = 8;
    defaultTimeout = 5000;
    font = "Roboto 12";
    layer = "overlay";
    progressColor = "#363a4f";
    textColor = "#cad3f5";
    width = 400;
    height = 300;

    extraConfig = ''
      [urgency=high]
      border-color=#f5a97f
    '';
  };
}
