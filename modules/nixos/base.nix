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
    kernelParams = [ "quiet" ];
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

  systemd.services.NetworkManager-wait-online.enable = false;

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
