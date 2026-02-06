return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      css = { "prettier" },
      go = { "goimports", "gofmt" },
      lua = { "stylua" },
      markdown = { "prettier" },
      nix = { "nixfmt" },
      python = { "isort", "black" },
      sh = { "shfmt" },
      terraform = { "terraform_fmt" },
      tf = { "terraform_fmt" },
      hcl = { "terraform_fmt" },
      yaml = { "prettier" },
    },
    formatters = {
      black = {
        prepend_args = { "--line-length", "120" },
      },
    },
  },
}
