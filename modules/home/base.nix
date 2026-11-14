{
  imports = [
    ./stylix.nix
    ./programs/alacritty.nix
    ./programs/atuin.nix
    ./programs/aws.nix
    ./programs/brave.nix
    ./programs/btop.nix
    ./programs/eza.nix
    ./programs/fastfetch.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/go.nix
    ./programs/gpg.nix
    ./programs/k8s.nix
    ./programs/neovim
    ./programs/opencode.nix
    ./programs/opentofu.nix
    ./programs/packages.nix
    ./programs/podman.nix
    ./programs/scripts
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/zsh.nix
  ];

  xdg.enable = true;
}
