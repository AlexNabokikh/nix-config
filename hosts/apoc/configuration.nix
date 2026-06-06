{
  inputs,
  hostname,
  lib,
  pkgs,
  userConfig,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../modules/docker.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = hostname;
  networking.useDHCP = lib.mkForce false;
  networking.networkmanager.enable = true;

  # Locale / time
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

  # Console / X11 keyboard
  console.keyMap = "uk";
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Docker
  docker.enable = true;

  # KDE Plasma
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Audio (pipewire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # SSH (key-only)
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # Allow flakes (matches morpheus/trinity)
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Trust nix-community.cachix so first-time pushes of pre-commit-hooks etc.
  # don't get rejected by `require-sigs = true` (default).
  nix.settings.extra-trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  # User (self-declared, not via vm-generic)
  users.users.${userConfig.name} = {
    isNormalUser = true;
    description = userConfig.fullName;
    extraGroups = ["networkmanager" "wheel" "docker"];
    openssh.authorizedKeys.keys = userConfig.sshKeys;
  };

  # Passwordless sudo → enables nixos-rebuild over SSH without a tty.
  security.sudo.wheelNeedsPassword = false;

  # Parallels shared-printer detection fails in this headless VM (no host
  # printers shared) and its activation failure propagates as switch exit
  # code 4. Disable to keep `just nixos-switch apoc` returning clean.
  systemd.services.prlshprint.enable = false;

  # Programs
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  system.stateVersion = "25.11";
}
