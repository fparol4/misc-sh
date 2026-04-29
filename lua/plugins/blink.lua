return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          auto_show = false,
        },
        documentation = {
          auto_show = false,
        },
        ghost_text = {
          enabled = false,
        },
      },
      cmdline = {
        completion = {
          menu = {
            auto_show = false,
          },
        },
      },
      keymap = {
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-@>"] = { "show", "show_documentation", "hide_documentation" },
      },
    },
  },
}
