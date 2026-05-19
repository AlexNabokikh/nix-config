{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
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
    };
}
