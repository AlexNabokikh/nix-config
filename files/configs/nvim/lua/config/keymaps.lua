-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>fa", function()
  return require("telescope.builtin").find_files({
    find_command = { "rg", "--files", "--hidden", "-g", "!.git/" },
    cwd = "~/Documents/repositories/",
  })
end, { desc = "Find all files in repositories directory" })
vim.keymap.set("n", "<leader>fh", function()
  return require("telescope.builtin").find_files({ find_command = { "rg", "--files", "--hidden", "-g", "!.git/" } })
end, { desc = "Find including hidden" })
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without overwriting the default register" })
vim.keymap.set("n", "<leader>dt", "<cmd>diffthis<CR>", { desc = "Diff This" })
