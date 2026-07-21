{
  flake.modules.homeManager.node =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nodejs ];

      programs.neovim.extraPackages = with pkgs; [
        prettier
        typescript-language-server
        vscode-langservers-extracted
      ];
    };
}
