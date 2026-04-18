{
  inputs,
  outputs,
  lib,
  config,
  userConfig,
  pkgs,
  ...
}: {
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];

    config.allowUnfree = true;
  };

  nix.registry = lib.mapAttrs (_: flake: {inherit flake;}) (lib.filterAttrs (_: lib.isType "flake") inputs);

  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings.experimental-features = "nix-command flakes";
  nix.optimise.automatic = true;

  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = ["quiet"];
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
    loader.timeout = 3;
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  environment.localBinInPath = true;

  users.users.${userConfig.name} = {
    description = userConfig.fullName;
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = userConfig.sshKeys;
  };

  users.users.root.openssh.authorizedKeys.keys = userConfig.sshKeys;

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    btop
    curl
    delta
    dig
    docker-compose
    dust
    eza
    fd
    git
    home-manager
    jq
    lazydocker
    lazygit
    neovim
    nh
    ripgrep
    tailscale
    tree
    unzip
    vim
  ];

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };
}
