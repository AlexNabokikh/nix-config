{
  flake.modules.homeManager.go =
    { config, pkgs, ... }:
    let
      GOPATH = "${config.home.homeDirectory}/go";
      GOBIN = "${GOPATH}/bin";
    in
    {

      home.packages = with pkgs; [
        golangci-lint
        gopls
        gotools
      ];

      programs.go = {
        enable = true;
        env = { inherit GOBIN GOPATH; };
      };

      programs.starship.settings.golang.symbol = " ";

      home.sessionPath = [
        GOBIN
      ];
    };
}
