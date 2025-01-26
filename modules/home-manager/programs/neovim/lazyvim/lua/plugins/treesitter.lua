return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    highlight = {
      enable = true,
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = 1000,
    },
    indent = {
      enable = true,
    },
    ensure_installed = {
      "bash",
      "c",
      "dockerfile",
      "go",
      "hcl",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "make",
      "markdown",
      "markdown_inline",
      "nix",
      "python",
      "regex",
      "terraform",
      "vim",
      "vimdoc",
      "yaml",
    },
  },
}
