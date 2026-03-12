local colorscheme = require("config.colorscheme")

return {
  {
    "EdenEast/nightfox.nvim",
    opts = {
      options = {
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = false,
      term_colors = true,
      integrations = {
        snacks = true,
        mini = true,
        notify = true,
        which_key = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = colorscheme,
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    enabled = false,
    opts = function(_, opts)
      opts.options.theme = colorscheme
    end,
  },
}
