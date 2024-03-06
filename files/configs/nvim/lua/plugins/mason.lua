return {
  {
    "williamboman/mason.nvim",
    -- Disable Mason in favor of Nix packages
    enabled = false,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "ansible-language-server",
        "ansible-lint",
        "bash-language-server",
        "black",
        "dockerfile-language-server",
        "goimports",
        "golangci-lint",
        "golangci-lint-langserver",
        "hadolint",
        "isort",
        "json-lsp",
        "lua-language-server",
        "markdownlint",
        "marksman",
        "prettier",
        "pyright",
        "ruff-lsp",
        "shfmt",
        "stylua",
        "terraform-ls",
        "tflint",
        "yaml-language-server",
      })
    end,
  },
}
