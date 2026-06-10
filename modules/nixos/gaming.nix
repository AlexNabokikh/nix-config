{
  flake.modules.nixos.gaming = {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    boot.kernelParams = [
      "split_lock_detect=off"
      "vsyscall=emulate"
    ];

    services.pipewire.extraConfig.pipewire."10-gaming" = {
      "context.properties" = {
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 256;
      };
    };
  };
}
