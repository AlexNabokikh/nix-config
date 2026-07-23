{
  flake.modules.homeManager.go =
    { config, ... }:
    let
      GOPATH = "${config.home.homeDirectory}/go";
      GOBIN = "${GOPATH}/bin";
    in
    {

      programs.go = {
        enable = true;
        env = { inherit GOBIN GOPATH; };
      };

      home.sessionPath = [
        GOBIN
      ];
    };
}
