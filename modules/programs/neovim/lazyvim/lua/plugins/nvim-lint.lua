return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      dockerfile = { "hadolint" },
      go = { "golangcilint" },
      javascript = { "eslint" },
      javascriptreact = { "eslint" },
      markdown = { "markdownlint" },
      opentofu = { "tflint" },
      terraform = { "tflint" },
    },
    linters = {
      markdownlint = {
        prepend_args = { "--disable", "MD013" },
      },
    },
  },
}
