return {
  {
    "mason-org/mason.nvim",
    -- Disable Mason in favor of Nix packages
    enabled = false,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    -- Disable mason-lspconfig since Mason is disabled
    enabled = false,
  },
}
