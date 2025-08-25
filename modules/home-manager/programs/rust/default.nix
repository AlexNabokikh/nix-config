{
  pkgs,
  lib,
  ...
}:
{
  # Rust development environment setup
  home.packages = with pkgs; [
    rustup
  ];

  # Ensure cargo binaries are in the path
  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  # Activation script to initialize rustup if needed
  home.activation.initRustup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -euo pipefail

    # Ensure the .cargo/bin directory exists for the PATH
    mkdir -p "$HOME/.cargo/bin"

    # Check if the 'stable' toolchain is installed
    if ! ${pkgs.rustup}/bin/rustup toolchain list | grep -q '^stable'; then
      ${pkgs.rustup}/bin/rustup toolchain install stable --profile default --no-self-update
    fi

    # Check if a default toolchain is set
    if ! ${pkgs.rustup}/bin/rustup show active-toolchain > /dev/null 2>&1; then
        ${pkgs.rustup}/bin/rustup default stable
    fi

    # Install essential components
    if ! ${pkgs.rustup}/bin/rustup component list --installed --toolchain stable | grep -q '^rust'; then
        ${pkgs.rustup}/bin/rustup component add --toolchain stable rustfmt clippy rust-analyzer
    fi
  '';
}
