{
  flake.modules.homeManager.opentofu =
    { pkgs, ... }:
    {

      home.packages = with pkgs; [
        opentofu
        tflint
        tofu-ls
      ];

      programs.starship.settings.terraform.symbol = " ";
      programs.zsh.shellAliases.terraform = "tofu";
    };
}
