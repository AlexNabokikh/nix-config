{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../common/base.nix
    ./gnome
  ];

  boot = {
    consoleLogLevel = 0;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      timeout = 0;
    };
    plymouth.enable = true;
  };

  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # CLI tools and the macOS docker shim live in modules/home/packages.nix.
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  users.users.${config.user.name} = {
    description = "Alexander Nabokikh";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    shell = config.programs.zsh.package;
  };

  security.sudo.wheelNeedsPassword = false;
}
