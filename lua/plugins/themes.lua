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
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nightfox",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    enabled = false,
    opts = function(_, opts)
      opts.options.theme = "nightfox"
    end,
  },
}
