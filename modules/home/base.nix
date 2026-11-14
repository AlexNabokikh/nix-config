{
  imports = [
    ./alacritty.nix
    ./git.nix
    ./k8s.nix
    ./neovim
    ./packages.nix
    ./podman.nix
    ./scripts
    ./shell.nix
    ./stylix.nix
    ./tmux.nix
  ];

  xdg.enable = true;
}
