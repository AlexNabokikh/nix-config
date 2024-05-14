{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # nixpkgs configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  # Boot settings
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = ["quiet" "splash"];
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
    loader.timeout = 0;
    plymouth.enable = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IE.UTF-8";
      LC_IDENTIFICATION = "en_IE.UTF-8";
      LC_MEASUREMENT = "en_IE.UTF-8";
      LC_MONETARY = "en_IE.UTF-8";
      LC_NAME = "en_IE.UTF-8";
      LC_NUMERIC = "en_IE.UTF-8";
      LC_PAPER = "en_IE.UTF-8";
      LC_TELEPHONE = "en_IE.UTF-8";
      LC_TIME = "en_IE.UTF-8";
    };
  };

  # Enable touchpad support
  services.libinput.enable = true;

  # X11 settings
  services.xserver = {
    enable = true;
    xkb = {
      layout = "pl";
      variant = "";
    };

    # Exclude certain default packages
    excludePackages = with pkgs; [xterm];

    # Set GDM as the default display manager
    displayManager.gdm.enable = true;
  };

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable storage services
  services.devmon.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nabokikh = {
    description = "Alexander Nabokikh";
    extraGroups = ["networkmanager" "wheel" "docker"];
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  # Enable passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # List of common packages
  environment.systemPackages = with pkgs; [
    anki
    argo-rollouts
    awscli2
    brave
    delta
    dig
    docker-compose
    du-dust
    eza
    fd
    gcc
    gimp
    glib
    gnome.dconf-editor
    gnumake
    go
    helmfile
    jq
    killall
    kind
    kubectl
    kubernetes-helm
    lazydocker
    mesa
    nh
    obs-studio
    openconnect
    (python3.withPackages (ps:
      with ps; [
        pip
        virtualenv
      ]))
    pipenv
    pulseaudio
    qt6.qtwayland
    resources
    ripgrep
    sops
    telegram-desktop
    terraform
    terragrunt
    unzip
    wget
    wl-clipboard
    zoom-us
  ];

  # Docker configuration
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Zsh configuration
  programs.zsh = {
    enable = true;
  };

  # Fonts configuration
  fonts.packages = with inputs.nixpkgs-stable.legacyPackages.x86_64-linux; [
    (nerdfonts.override {fonts = ["Meslo" "JetBrainsMono"];})
    roboto
  ];

  # List services that you want to enable:
  services.locate.enable = true;
  services.locate.localuser = null;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
