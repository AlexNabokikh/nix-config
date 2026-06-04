{...}: {
  imports = [
    ../modules/home.nix
    ../modules/common.nix
    ../modules/starship.nix
    ../modules/zsh.nix
  ];

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.05";
}
