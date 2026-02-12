return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      ui = { position = "right" },
    },
    picker = {
      hidden = true,
    },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
██████╗ ██╗  ██╗
██╔═████╗╚██╗██╔╝
██║██╔██║ ╚███╔╝ 
████╔╝██║ ██╔██╗ 
╚██████╔╝██╔╝ ██╗
╚═════╝ ╚═╝  ╚═╝
]],
        -- stylua: ignore
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
