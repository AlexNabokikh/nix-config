{
  flake.modules.nixos.podman = {
    virtualisation.podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  flake.modules.homeManager.podman =
    { lib, pkgs, ... }:
    let
      docker = pkgs.writeShellScriptBin "docker" ''
        exec ${pkgs.podman}/bin/podman "$@"
      '';
    in
    {
      home.packages =
        with pkgs;
        [
          docker
          hadolint
          podman-compose
          podman-tui
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ podman ];

      programs.zsh.shellAliases.pt = "podman-tui";
    };
}
