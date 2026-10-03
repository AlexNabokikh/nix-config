return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      css = { "prettier" },
      go = { "goimports" },
      hcl = { "tofu_fmt" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      nix = { "nixfmt" },
      opentofu = { "tofu_fmt" },
      ["opentofu-vars"] = { "tofu_fmt" },
      python = { "ruff_organize_imports", "ruff_format" },
      sh = { "shfmt" },
      terraform = { "tofu_fmt" },
      ["terraform-vars"] = { "tofu_fmt" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      yaml = { "prettier" },
    },
  },
}
