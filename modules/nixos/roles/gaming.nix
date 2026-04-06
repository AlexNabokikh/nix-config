{ ... }:
{
  flake.modules.nixos.gaming =
    { config, pkgs, ... }:
    {
      programs.gamemode = {
        enable = true;
        settings = {
          general.renice = 10;
          cpu.governor = "performance";
          gpu = {
            apply_gpu_optimisations = "accept-responsibility";
            gpu_device = 1;
            amd_performance_level = "high";
          };
        };
      };

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        package = pkgs.steam.override {
          extraEnv = {
            AMD_VULKAN_ICD = "RADV";
          };
        };
      };

      boot.kernelParams = [ "split_lock_detect=off" ];

      services.pipewire.extraConfig.pipewire."10-gaming" = {
        "context.properties" = {
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 256;
        };
      };

      users.users.${config.primaryUser}.extraGroups = [ "gamemode" ];
    };
}
