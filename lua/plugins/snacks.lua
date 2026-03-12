return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
    picker = {
      actions = {
        explorer_focus_global_cwd = function(picker)
          local cwd = picker:dir()
          picker:set_cwd(cwd)
          vim.cmd.cd(cwd)
          vim.g.project_root = cwd
          picker:find()
        end,
        explorer_yank_relative = function(picker)
          local files = {}
          local base = vim.g.project_root or picker:cwd()

          if vim.fn.mode():find("^[vV]") then
            picker.list:select()
          end

          for _, item in ipairs(picker:selected({ fallback = true })) do
            local path = require("snacks.picker.util").path(item)
            table.insert(files, vim.fs.relpath(base, path) or path)
          end

          picker.list:set_selected()
          vim.fn.setreg(vim.v.register or "+", table.concat(files, "\n"), "l")
          Snacks.notify.info("Yanked " .. #files .. " relative paths")
        end,
      },
      sources = {
        explorer = {
          layout = { layout = { position = "right" } },
          follow_file = false,
          cwd = vim.g.project_root,
          win = {
            list = {
              keys = {
                ["."] = "explorer_focus_global_cwd",
                ["Y"] = { "explorer_yank_relative", mode = { "n", "x" } },
              },
            },
          },
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
