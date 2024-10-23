{...}: {
  # Set TLP power profile
  services = {
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "balance-power";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        PLATFORM_PROFILE_ON_AC = "low-power";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        USB_EXCLUDE_BTUSB = 1;

        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

        DISK_IOSCHED = ["none"];

        # Battery charge thresholds for office usage
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 50;

        # Battery charge thresholds for on-road usage
        # START_CHARGE_THRESH_BAT0 = 85;
        # STOP_CHARGE_THRESH_BAT0 = 90;
      };
    };
    power-profiles-daemon = {
      enable = false;
    };
  };

  # Disable fingerprint reader
  services.fprintd.enable = false;
}
