return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      bashls = {},
      gopls = {
        settings = {
          gopls = {
            analyses = {
              nilness = false,
              printf = false,
              unusedparams = false,
            },
          },
        },
      },
      jsonls = {},
      nixd = {
        cmd = { "nixd", "--log=error" },
      },
      pyright = {
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              typeCheckingMode = "basic",
            },
          },
        },
      },
      ruff = {},
      tofu_ls = {},
      yamlls = {
        settings = {
          yaml = {
            keyOrdering = false,
          },
        },
      },
    },
  },
}
