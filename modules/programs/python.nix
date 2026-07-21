{
  flake.modules.homeManager.python =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        pipenv
        pyright
        python3
        ruff
      ];
    };
}
