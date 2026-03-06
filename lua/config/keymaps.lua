vim.keymap.set("n", "<leader>e", function()
  Snacks.explorer({ cwd = vim.g.project_root })
end, { desc = "File Explorer (Root)" })
