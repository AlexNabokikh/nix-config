{
  flake.modules.homeManager.python =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        pipenv
        python3
      ];

      programs.neovim.extraPackages = with pkgs; [
        pyright
        ruff
      ];

      programs.starship.settings.python.symbol = " ";
    };
}
