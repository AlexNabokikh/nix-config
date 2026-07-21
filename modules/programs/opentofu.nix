{
  flake.modules.homeManager.opentofu =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.opentofu ];

      programs.neovim.extraPackages = with pkgs; [
        tflint
        tofu-ls
      ];

      programs.starship.settings.terraform.symbol = " ";
      programs.zsh.shellAliases.terraform = "tofu";
    };
}
