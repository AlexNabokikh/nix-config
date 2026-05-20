return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      css = { "prettier" },
      go = { "goimports", "gofmt" },
      hcl = { "tofu_fmt" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      nix = { "nixfmt" },
      python = { "ruff_organize_imports", "ruff_format" },
      sh = { "shfmt" },
      terraform = { "tofu_fmt" },
      tf = { "tofu_fmt" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      yaml = { "prettier" },
    },
    formatters = {
      ruff_format = {
        prepend_args = { "--line-length", "120" },
      },
    },
  },
}
