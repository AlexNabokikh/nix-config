{
  description = "NixOS and nix-darwin configs for my machines";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS profiles to optimize settings for different hardware
    hardware.url = "github:nixos/nixos-hardware";

    # Global catppuccin theme
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Darwin (for MacOS machines)
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Zsh plugins
    zsh-autosuggestions = {
      url = "github:zsh-users/zsh-autosuggestions";
      flake = false;
    };
    zsh-history-substring-search = {
      url = "github:zsh-users/zsh-history-substring-search";
      flake = false;
    };

    # Pre-commit hooks
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    catppuccin,
    darwin,
    home-manager,
    nix-homebrew,
    nixpkgs,
    pre-commit-hooks,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Systems to support
    systems = ["x86_64-linux" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    pkgsFor = system: import nixpkgs {localSystem = system;};

    # Define user configurations by importing from separate files for modularity and privacy
    users = {
      fs = import ./users/fs.nix;
    };

    # Function for NixOS system configuration
    mkNixosConfiguration = hostname: username:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
        };
        modules = [./hosts/${hostname}/configuration.nix];
      };

    # Function for nix-darwin system configuration
    mkDarwinConfiguration = hostname: username:
      darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
        };
        modules = [
          ./hosts/${hostname}/configuration.nix
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };

    # Function for Home Manager configuration
    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {localSystem = system;};
        extraSpecialArgs = {
          inherit inputs outputs;
          userConfig = users.${username};
        };
        modules = [
          ./home/${username}/${hostname}.nix
          catppuccin.homeModules.catppuccin
        ];
      };
  in {
    nixosConfigurations = {
      "nixos" = mkNixosConfiguration "nixos" "fs";
    };

    darwinConfigurations = {
      "macvm-fs" = mkDarwinConfiguration "macvm-fs" "fs";
      "macpro-fs" = mkDarwinConfiguration "macpro-fs" "fs";
    };

    homeConfigurations = {
      "fs@nixos" = mkHomeConfiguration "x86_64-linux" "fs" "nixos";
      "fs@macvm-fs" = mkHomeConfiguration "aarch64-darwin" "fs" "macvm-fs";
      "fs@macpro-fs" = mkHomeConfiguration "aarch64-darwin" "fs" "macpro-fs";
    };

    overlays = import ./overlays {inherit inputs;};

    # Pre-commit hooks check
    checks = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          # Nix formatting (blocks commits if code isn't formatted)
          alejandra.enable = true;

          # YAML validation
          check-yaml.enable = true;

          # TOML validation
          check-toml.enable = true;

          # JSON validation
          check-json.enable = true;
        };
      };
    });

    # Development shells with pre-commit
    devShells = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      default = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        packages = with pkgs; [
          alejandra # Nix formatter
          statix # Nix linter
          deadnix # Dead code detector
          nil # Nix LSP
        ];
      };
    });

    # Formatter for nix fmt
    formatter = forAllSystems (system: (pkgsFor system).alejandra);
  };
}
