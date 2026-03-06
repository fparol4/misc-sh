return {
  {
    "akinsho/bufferline.nvim",
    enabled = true,
    opts = {
      options = {
        themable = true,
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "nvim-mini/mini.icons",
    opts = {
      style = "glyph",
    },
    config = function(_, opts)
      local mini_icons = require("mini.icons")
      mini_icons.setup(opts)

      local orig_get = mini_icons.get
      mini_icons.get = function(category, name)
        if category == "file" then
          return orig_get("default", "file")
        end
        return orig_get(category, name)
      end
      mini_icons.mock_nvim_web_devicons()

      local function set_dark_icons()
        local groups = {
          "MiniIconsAzure",
          "MiniIconsBlue",
          "MiniIconsCyan",
          "MiniIconsGreen",
          "MiniIconsGrey",
          "MiniIconsOrange",
          "MiniIconsPurple",
          "MiniIconsRed",
          "MiniIconsYellow",
        }
        for _, group in ipairs(groups) do
          vim.api.nvim_set_hl(0, group, { link = "Comment" })
        end
      end

      set_dark_icons()

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_dark_icons,
      })
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },
}
