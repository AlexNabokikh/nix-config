return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      css = { "prettier" },
      go = { "goimports", "gofmt" },
      hcl = { "terraform_fmt" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      nix = { "nixfmt" },
      python = { "isort", "black" },
      sh = { "shfmt" },
      terraform = { "terraform_fmt" },
      tf = { "terraform_fmt" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      yaml = { "prettier" },
    },
    formatters = {
      black = {
        prepend_args = { "--line-length", "120" },
      },
    },
  },
}
