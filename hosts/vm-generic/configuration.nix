{
  inputs,
  hostname,
  lib,
  modulesPath,
  pkgs,
  userConfig,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
  ];

  # Core VM settings (generic for all Proxmox VMs)
  networking.hostName = hostname;
  networking.useDHCP = false;
  networking.usePredictableInterfaceNames = false;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.kernelParams = ["console=tty0"];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.enable = false;
    systemd-boot.enable = true;
  };
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.optimise.automatic = true;

  services.qemuGuest.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  networking.firewall.enable = true;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${userConfig.name} = {
    description = userConfig.fullName;
    extraGroups = ["wheel" "docker"];
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = userConfig.sshKeys;
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    curl
    docker-compose
    git
    home-manager
    htop
    jq
    ripgrep
    vim
  ];

  programs.zsh.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless.enable = true;
  virtualisation.docker.rootless.setSocketVariable = true;

  system.stateVersion = "25.05";
}
