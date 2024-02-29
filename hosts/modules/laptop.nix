{...}: {
  # Set TLP power profile
  services = {
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "balanced";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = ["bluetooth" "wifi" "wwan"];
        DEVICES_TO_ENABLE_ON_AC = ["bluetooth" "wifi" "wwan"];

        RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

        DISK_IOSCHED = ["none"];

        START_CHARGE_THRESH_BAT0 = 30;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    power-profiles-daemon = {
      enable = false;
    };
  };
}
