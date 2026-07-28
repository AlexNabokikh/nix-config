{
  flake.modules.nixos.podman = {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  flake.modules.homeManager.podman =
    { lib, pkgs, ... }:
    let
      docker = pkgs.writeShellScriptBin "docker" ''
        exec ${lib.getExe pkgs.podman} "$@"
      '';
    in
    {
      home.packages =
        with pkgs;
        [
          podman-compose
          podman-tui
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
          docker
          podman
        ];

      programs.zsh.shellAliases.pt = "podman-tui";
    };
}
