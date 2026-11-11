{
  flake.modules.homeManager.neovim =
    {
      config,
      pkgs,
      ...
    }:
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        sideloadInitLua = true;
        vimAlias = true;

        # Runs before init.lua; read by lua/plugins/colorscheme.lua.
        initLua = ''vim.g.stylix_base00 = "${config.lib.stylix.colors.withHashtag.base00}"'';

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

      xdg.configFile."nvim" = {
        source = ./lazyvim;
        recursive = true;
      };
    };
}
