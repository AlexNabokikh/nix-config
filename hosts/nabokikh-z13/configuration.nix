{inputs, ...}: {
  imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-z13

    ./hardware-configuration.nix
    ../modules/common.nix
    ../modules/hyprland.nix
  ];

  # Set hostname
  networking.hostName = "nabokikh-z13";

  # Set TLP settings
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "balanced";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = ["bluetooth" "wifi"];
      DEVICES_TO_ENABLE_ON_AC = ["bluetooth" "wifi"];

      RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

      DISK_IOSCHED = ["none"];

      START_CHARGE_THRESH_BAT0 = 30;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "23.11";
}
