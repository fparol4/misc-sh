-- GENERAL
vim.opt.autochdir = false
vim.g.autoformat = false
vim.opt.conceallevel = 0
vim.g.project_root = vim.uv.cwd()
vim.g.transparent_explorer = true

-- TAB (4 SPACES)
-- vim.opt.tabstop = 4
-- vim.opt.shiftwidth = 4
-- vim.opt.softtabstop = 4
-- vim.opt.expandtab = true

-- TAB (2 SPACES)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = false

-- OTHER
vim.opt.clipboard = ""
vim.opt.laststatus = 0
vim.opt.wrap = true
vim.diagnostic.enable(false)
vim.lsp.inlay_hint.enable(false)
