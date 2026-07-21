{
  flake.modules.homeManager.node =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nodejs
        prettier
        typescript-language-server
        vscode-langservers-extracted
      ];
    };
}
