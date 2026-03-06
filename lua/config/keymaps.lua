vim.keymap.set("n", "<leader>e", function()
  Snacks.explorer({ cwd = vim.g.project_root })
end, { desc = "File Explorer (Root)" })

vim.keymap.set("n", "<leader><leader>", function()
  Snacks.picker.files({ cwd = vim.g.project_root })
end, { desc = "Find Files (Root)" })
