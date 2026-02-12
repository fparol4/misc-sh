-- LSP settings are handled by the lazyvim.plugins.extras.lang.typescript extra.
-- Only add custom overrides here.
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      vtsls = {
        settings = {
          vtsls = {
            autoUseWorkspaceTsdk = true,
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
          },
        },
      },
    },
  },
}
