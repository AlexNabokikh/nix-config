# Nix Package Overrides
# Purpose: Provides access to stable nixpkgs via pkgs.stable
{inputs, ...}: let
  fuelcheck-cli = final: prev: (prev.rustPlatform.buildRustPackage {
    pname = "fuelcheck-cli";
    version = "unstable";
    src = prev.fetchFromGitHub {
      owner = "chasebuild";
      repo = "fuelcheck-cli";
      rev = "main";
      sha256 = "sha256-0i25dq9xyfsyxkg05w46j08xivqisrfk1l98g6g2g0nczahz8ss4";
    };
    cargoSha256 = "sha256-0000000000000000000000000000000000000000000000000000=";
  });
in {
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

  # Fix direnv build issues by disabling tests (often hangs on macOS)
  direnv-no-tests = final: prev: {
    direnv = prev.direnv.overrideAttrs (old: {
      doCheck = false;
    });
  };

  # Add fuelcheck-cli from source
  fuelcheck-cli = fuelcheck-cli;
}
