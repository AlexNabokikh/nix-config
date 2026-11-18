{ lib, ... }:
{
  imports = [
    ./alacritty.nix
    ./btop.nix
    ./git.nix
    ./k8s.nix
    ./neovim
    ./opencode.nix
    ./packages.nix
    ./scripts
    ./shell.nix
    ./tmux.nix
  ];

  home.stateVersion = lib.mkDefault "26.05";
  xdg.enable = true;
}
