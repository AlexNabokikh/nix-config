{...}: {
  # Steam gaming platform configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
