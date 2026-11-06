{
  flake.modules.homeManager.neovim =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        sideloadInitLua = true;
        vimAlias = true;

        extraPackages = with pkgs; [
          bash-language-server
          eslint
          golangci-lint
          gopls
          gotools
          hadolint
          helm-ls
          lua-language-server
          markdownlint-cli
          nixd
          nixfmt
          prettier
          pyright
          ruff
          shfmt
          stylua
          tflint
          tofu-ls
          tree-sitter
          vscode-langservers-extracted
          yaml-language-server
        ];
      };

      xdg.configFile = {
        # Data rather than a Lua module: vim.loader caches modules by size and mtime, and both
        # stay constant across generations for Nix store files, so palette changes would be missed.
        "nvim/stylix.json".text =
          let
            palette = lib.genAttrs [
              "base00"
              "base01"
              "base02"
              "base03"
              "base04"
              "base05"
              "base06"
              "base07"
              "base08"
              "base09"
              "base0A"
              "base0B"
              "base0C"
              "base0D"
              "base0E"
              "base0F"
            ] (name: config.lib.stylix.colors.withHashtag.${name});
          in
          builtins.toJSON palette;

        "nvim" = {
          source = ./lazyvim;
          recursive = true;
        };
      };
    };
}
