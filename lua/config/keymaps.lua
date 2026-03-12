vim.keymap.set("n", "<leader>e", function()
  Snacks.explorer({ cwd = vim.g.project_root })
end, { desc = "File Explorer (Root)" })

vim.keymap.set("n", "<leader><leader>", function()
  Snacks.picker.files({ cwd = vim.g.project_root })
end, { desc = "Find Files (Root)" })

vim.keymap.set("n", "<X1Mouse>", "<C-o>", { desc = "Jump Back" })
vim.keymap.set("n", "<X2Mouse>", "<C-i>", { desc = "Jump Forward" })
