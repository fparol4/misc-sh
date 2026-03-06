return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      enabled = true,
      replace_netrw = false,
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
        header = [[
███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║   ██║██║████╗ ████║
██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],
        keys = {
          { icon = " ", key = "f", desc = "Files", action = ":lua LazyVim.pick()()" },
          { icon = " ", key = "r", desc = "Recent", action = ":lua LazyVim.pick('oldfiles')()" },
          { icon = " ", key = "g", desc = "Search", action = ":lua LazyVim.pick('live_grep')()" },
          { icon = " ", key = "s", desc = "Restore", section = "session" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { text = { { "fparol4 λ", hl = "special" } }, align = "center" },
      },
    },
  },
}
