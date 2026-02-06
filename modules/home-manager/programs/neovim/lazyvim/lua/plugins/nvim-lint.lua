return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      dockerfile = { "hadolint" },
      go = { "golangcilint" },
      markdown = { "markdownlint" },
      terraform = { "tflint" },
      tf = { "tflint" },
    },
    linters = {
      markdownlint = {
        prepend_args = { "--disable", "MD013" },
      },
    },
  },
}
