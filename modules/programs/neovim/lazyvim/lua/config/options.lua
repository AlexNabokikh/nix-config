-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.winbar = "%=%m %f"
vim.g.snacks_animate = false

-- Classify empty and comment-only .tf files before the first buffer is opened.
vim.filetype.add({
  extension = {
    tf = "terraform",
  },
})
