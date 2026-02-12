return {
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  init = function()
    -- Use default mappings
    vim.g.VM_default_mappings = 1
    -- Leader key for VM commands
    vim.g.VM_leader = "\\"
    -- Custom mappings
    vim.g.VM_maps = {
      ["Find Under"] = "<C-n>",
      ["Find Subword Under"] = "<C-n>",
      ["Add Cursor Down"] = "<C-Down>",
      ["Add Cursor Up"] = "<C-Up>",
    }
  end,
  keys = {
    { "<C-n>", mode = { "n", "x" }, desc = "Add cursor at word" },
    { "<C-Down>", mode = { "n", "x" }, desc = "Add cursor down" },
    { "<C-Up>", mode = { "n", "x" }, desc = "Add cursor up" },
    { "\\\\", mode = { "n", "x" }, desc = "Visual Multi" },
  },
}
