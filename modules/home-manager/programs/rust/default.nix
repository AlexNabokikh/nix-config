{
  pkgs,
  lib,
  ...
}: {
  # Rust development environment setup
  home.packages = with pkgs; [
    rustup
  ];

  # Ensure cargo binaries are in the path
  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  # Activation script to initialize rustup if needed
  home.activation.initRustup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Ensure the .cargo/bin directory exists for the PATH
    mkdir -p "$HOME/.cargo/bin"

    # Check if the 'stable' toolchain is installed
    if ! ${pkgs.rustup}/bin/rustup toolchain list | grep -q '^stable'; then
      echo "Rustup 'stable' toolchain not found. Installing..."
      ${pkgs.rustup}/bin/rustup toolchain install stable --profile default --no-self-update
      echo "Stable toolchain installed."
    fi

    # Check if a default toolchain is set
    if ! ${pkgs.rustup}/bin/rustup show active-toolchain > /dev/null 2>&1; then
        echo "No default rustup toolchain configured. Setting 'stable' as default..."
        ${pkgs.rustup}/bin/rustup default stable
        echo "Set 'stable' as default toolchain."
    fi

    # Check and install essential components
    COMPONENT_CHECK_FILE="$HOME/.config/rustup_components_checked"
    if [ ! -f "$COMPONENT_CHECK_FILE" ] || [ "$(find "$COMPONENT_CHECK_FILE" -mmin +1440 2>/dev/null)" ]; then
        echo "Checking/Installing essential Rust components (fmt, clippy)..."
        ${pkgs.rustup}/bin/rustup component add rustfmt clippy rust-analyzer || echo "Failed to add some components"
        touch "$COMPONENT_CHECK_FILE"
        echo "Essential components checked/installed."
    fi
  '';
}
