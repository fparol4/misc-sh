return {
  "folke/snacks.nvim",
  init = function()
    local function apply_explorer_transparency()
      if not vim.g.transparent_explorer then return end
      local groups = {
        "SnacksPicker",
        "SnacksPickerList",
        "SnacksPickerInput",
        "SnacksPickerBox",
        "SnacksPickerBorder",
        "SnacksPickerTitle",
      }
      for _, group in ipairs(groups) do
        local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
        hl.bg = nil
        hl.ctermbg = nil
        vim.api.nvim_set_hl(0, group, hl)
      end
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = apply_explorer_transparency,
    })

    apply_explorer_transparency()
  end,
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
              wo = {
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
              },
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
    styles = {
      explorer = {
        backdrop = false,
        wo = {
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
      },
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
