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

  # Bootloader.
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot = {
    kernelParams = ["quiet" "splash"];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Internationalization settings
  i18n.extraLocaleSettings = {
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

  # Enable the GNOME Desktop Environment.
  services.xserver = {
    enable = true; # X11 is enabled as a dependency of GNOME
    layout = "pl"; # Configure keymap in X11
    xkbVariant = "";
    libinput.enable = true; # Enable touchpad support

    # Exclude certain default packages
    excludePackages = with pkgs; [xterm];

    displayManager.gdm.enable = true; # Enable GNOME Display Manager
    desktopManager.gnome.enable = true; # Enable GNOME
  };

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Enable CUPS to print documents.
  services.printing.enable = false;

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

  # Excluding some GNOME applications from the default install
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
      snapshot
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      gnome-contacts
      gedit
      simple-scan
      gnome-maps
      epiphany # web browser
      geary # email reader
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    anki
    argo-rollouts
    awscli2
    bottom
    brave
    delta
    du-dust
    eza
    fd
    ffmpeg
    gcc
    gimp
    jq
    gnome.dconf-editor
    gnome.gnome-session
    gnome.gnome-shell-extensions
    gnome.gnome-tweaks
    gnome.pomodoro
    gnomeExtensions.blur-my-shell
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-history
    gnomeExtensions.dash-to-dock
    gnomeExtensions.forge
    gnomeExtensions.just-perfection
    gnomeExtensions.space-bar
    gnomeExtensions.unblank
    gnomeExtensions.user-themes
    gnumake
    go
    helmfile
    kind
    kubectl
    kubernetes-helm
    lazydocker
    lazygit
    mesa
    neofetch
    normcap
    obs-studio
    openconnect
    (python3.withPackages (ps:
      with ps; [
        pip
        pre-commit
        virtualenv
      ]))
    pulseaudio
    qt6.qtwayland
    ripgrep
    sops
    telegram-desktop
    terraform
    terragrunt
    unzip
    vlc
    wget
    wl-clipboard
    zoom-us
    zsh
    zsh-powerlevel10k
  ];

  # Docker configuration
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Git
  programs.git.enable = true;

  # GnuPG agent configuration
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Zsh configuration
  programs.zsh = {
    enable = true;
  };

  # Fonts configuration
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["Meslo"];})
    roboto
  ];

  # List services that you want to enable:
  services.locate.enable = true;
  services.locate.localuser = null;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "23.11";
}
