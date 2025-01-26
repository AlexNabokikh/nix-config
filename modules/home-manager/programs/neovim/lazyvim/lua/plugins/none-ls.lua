return {
  "nvimtools/none-ls.nvim",
  opts = function()
    local nls = require("null-ls")
    return {
      root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
      sources = {
        -- code actions
        -- formatters
        nls.builtins.formatting.alejandra,
        nls.builtins.formatting.black.with({
          extra_args = { "--line-length", "120" },
        }),
        nls.builtins.formatting.prettier.with({
          filetypes = {
            "css",
            "markdown",
            "yaml.docker-compose",
            "yaml.kubernetes",
            "yaml",
          },
        }),
        nls.builtins.formatting.goimports,
        nls.builtins.formatting.isort,
        nls.builtins.formatting.markdownlint,
        nls.builtins.formatting.shfmt,
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.terraform_fmt,
        -- linters
        nls.builtins.diagnostics.golangci_lint,
        nls.builtins.diagnostics.hadolint,
        nls.builtins.diagnostics.markdownlint.with({ extra_args = { "--disable", "MD013" } }),
      },
      on_attach = function(client, bufnr)
        -- Disable diagnostics for helm files
        if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
          vim.diagnostic.disable(bufnr)
        end
      end,
    }
  end,
}
