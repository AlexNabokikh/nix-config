# Nix Package Overlays
# Purpose: Provides access to stable nixpkgs via pkgs.stable
{inputs, ...}: {
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      localSystem = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  # Fix fish build issues by disabling tests
  fish-no-tests = final: prev: {
    fish = prev.fish.overrideAttrs (old: {
      doCheck = false;
    });
  };
}
