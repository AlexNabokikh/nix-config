return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    -- LazyVim extends its default parser list; only list additions here.
    ensure_installed = {
      "dockerfile",
      "go",
      "hcl",
      "make",
      "nix",
      "terraform",
    },
  },
}
