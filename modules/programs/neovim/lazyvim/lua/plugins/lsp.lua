return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          settings = {
            bashIde = {
              shellcheckPath = "",
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              semanticTokens = true,
              analyses = {
                fieldalignment = false,
                nilness = false,
                printf = false,
                shadow = false,
                unusedparams = false,
              },
              staticcheck = false,
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false,
              },
            },
          },
        },
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        nixd = {
          settings = {
            nixd = {
              formatting = {
                command = { "nixfmt" },
              },
            },
          },
        },
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
        ruff = {},
        tofu_ls = {
          filetypes = { "opentofu", "opentofu-vars", "terraform", "terraform-vars" },
        },
        ts_ls = {},
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
      },
    },
  },
}
