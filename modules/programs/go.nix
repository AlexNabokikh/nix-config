{
  flake.modules.homeManager.go =
    { config, pkgs, ... }:
    let
      GOPATH = "${config.home.homeDirectory}/go";
      GOBIN = "${GOPATH}/bin";
    in
    {
      home.packages = [ pkgs.golangci-lint ];

      programs.go = {
        enable = true;
        env = { inherit GOBIN GOPATH; };
      };

      home.sessionPath = [
        GOBIN
      ];
    };
}
