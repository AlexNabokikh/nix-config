{
  flake.modules.homeManager.opentofu =
    { pkgs, ... }:
    {

      home.packages = with pkgs; [
        opentofu
      ];

      programs.zsh.shellAliases.terraform = "tofu";
    };
}
