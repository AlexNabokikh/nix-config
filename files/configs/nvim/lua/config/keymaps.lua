-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>aa", "<cmd>Dashboard<CR>", { desc = "Go to Dashboard Menu" })
vim.keymap.set("n", "<leader>fa", function()
  return require("telescope.builtin").find_files({
    find_command = { "rg", "--files", "--hidden", "-g", "!.git/" },
    cwd = "~/Documents/repositories/",
  })
end, { desc = "Find all files in repositories directory" })
vim.keymap.set("n", "<leader>fh", function()
  return require("telescope.builtin").find_files({ find_command = { "rg", "--files", "--hidden", "-g", "!.git/" } })
end, { desc = "Find including hidden" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<Esc><Esc>", "<Esc>", { desc = "Exit terminal mode" })
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without overwriting the default register" })
vim.keymap.set("n", "<leader>dt", "<cmd>diffthis<CR>", { desc = "Diff This" })
