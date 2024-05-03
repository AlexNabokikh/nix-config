{pkgs, ...}: let
  config = ./../../files/configs/fastfetch;
in {
  # Install fastfetch via home-manager package
  home.packages = with pkgs; [
    fastfetch
  ];

  # Source fastfetch config from the home-manager store
  home.file = {
    ".config/fastfetch" = {
      recursive = true;
      source = "${config}";
    };
  };
}
