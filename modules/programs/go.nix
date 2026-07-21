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

      programs.neovim.extraPackages = with pkgs; [
        golangci-lint
        gopls
        gotools
      ];

      programs.starship.settings.golang.symbol = " ";

      home.sessionPath = [
        GOBIN
      ];
    };
}
