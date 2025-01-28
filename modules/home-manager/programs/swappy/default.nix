{pkgs, ...}: {
  # Ensure swappy package installed
  home.packages = with pkgs; [
    swappy
  ];

  # Source swappy config from the home-manager store
  xdg.configFile = {
    "swappy/config".text = ''
      [Default]
      save_dir=$HOME/Pictures
      save_filename_format=screenshot-%Y%m%d-%H%M%S.png
    '';
  };
}
