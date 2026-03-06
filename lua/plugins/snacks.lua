return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
    picker = {
      sources = {
        explorer = {
          layout = { layout = { position = "right" } },
          follow_file = false,
          cwd = vim.g.project_root,
        },
      },
      hidden = true,
    },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua LazyVim.pick()()" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua LazyVim.pick('oldfiles')()" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua LazyVim.pick('live_grep')()" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "c", desc = "Config", action = ":lua LazyVim.pick.config_files()" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
  },
}
