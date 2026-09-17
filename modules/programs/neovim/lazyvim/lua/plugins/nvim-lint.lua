return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      dockerfile = { "hadolint" },
      go = { "golangcilint" },
      javascript = { "eslint" },
      javascriptreact = { "eslint" },
      markdown = { "markdownlint" },
      sh = { "shellcheck" },
      terraform = { "tflint" },
      tf = { "tflint" },
      typescript = { "eslint" },
      typescriptreact = { "eslint" },
    },
    linters = {
      markdownlint = {
        prepend_args = { "--disable", "MD013" },
      },
    },
  },
}
