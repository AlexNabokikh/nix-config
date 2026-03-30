# Module: Environment Variables Management
# Purpose: Load environment variables and secrets from Doppler
# Platform: All
{
  config,
  pkgs,
  ...
}: {
  # Create a shell script to load environment variables and secrets from Doppler
  home.file.".doppler-secrets.sh" = {
    text = ''
      # Source this file in your shell rc to load environment variables and secrets from Doppler
      # It exports both secret and non-secret environment variables
      eval "$(doppler secrets download --no-file --format sh)"
    '';
  };

  # Create helper script to refresh environment variables
  home.file.".local/bin/doppler-refresh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      if ! command -v doppler &> /dev/null; then
        echo "Error: doppler CLI is not installed"
        exit 1
      fi

      if [ ! -f "$HOME/.doppler.yaml" ]; then
        echo "Error: .doppler.yaml not found. Run 'doppler setup' first"
        exit 1
      fi

      echo "🔄 Loading environment from Doppler..."
      eval "$(doppler secrets download --no-file --format sh)"

      echo "✅ Environment loaded successfully!"
      echo ""
      echo "Available environment variables:"
      doppler secrets list --plain
    '';
  };

  # Activation script to load environment variables on profile activation
  home.activation.loadDopplerSecrets = config.lib.dag.entryAfter ["writeBoundary"] ''
    # Load Doppler environment variables if doppler is available and .doppler.yaml exists
    if command -v doppler &> /dev/null && [ -f "$HOME/.doppler.yaml" ]; then
      $DRY_RUN_CMD eval "$(doppler secrets download --no-file --format sh 2>/dev/null)" || true
    fi
  '';
}
