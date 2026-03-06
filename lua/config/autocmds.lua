local function sync_project_root(path)
  vim.g.project_root = path or vim.uv.cwd()
end

vim.api.nvim_create_autocmd("DirChanged", {
  callback = function(args)
    sync_project_root(args.file)
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    sync_project_root()

    if vim.fn.argc() ~= 1 then
      return
    end

    local arg0 = vim.fn.argv(0)
    if arg0 ~= "." then
      return
    end

    vim.schedule(function()
      pcall(vim.cmd, "silent! %bwipeout")
      if Snacks and Snacks.dashboard then
        Snacks.dashboard()
      end
    end)
  end,
})
