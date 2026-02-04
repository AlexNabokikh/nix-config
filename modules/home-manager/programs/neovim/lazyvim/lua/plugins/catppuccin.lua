local flavor = os.getenv("CATPPUCCIN_FLAVOR") or "macchiato"

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-" .. flavor,
    },
  },
}
