{
  flake.modules.homeManager.opentofu =
    { pkgs, ... }:
    {

      home.packages = with pkgs; [
        opentofu
        tflint
        tofu-ls
      ];

      programs.zsh.shellAliases.terraform = "tofu";
    };
}
