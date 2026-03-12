vim.g.startup_cwd = vim.g.startup_cwd or vim.uv.cwd()

local function sync_project_root(path)
  vim.g.project_root = path or vim.g.startup_cwd or vim.uv.cwd()
end

vim.api.nvim_create_autocmd("DirChanged", {
  callback = function(args)
    sync_project_root(args.file)
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local argc = vim.fn.argc()
    local arg0 = argc == 1 and vim.fn.argv(0) or nil
    local startup_cwd = vim.uv.cwd()
    local is_dir = arg0 and vim.fn.isdirectory(arg0) == 1

    vim.g.startup_cwd = startup_cwd

    if is_dir then
      local dir = vim.fn.fnamemodify(arg0, ":p")
      vim.cmd.cd(dir)
      sync_project_root(dir)
    elseif arg0 then
      local file_dir = vim.fn.fnamemodify(arg0, ":p:h")
      vim.cmd.cd(file_dir)
      sync_project_root(file_dir)
    else
      sync_project_root(startup_cwd)
    end

    if not is_dir then
      return
    end

    vim.schedule(function()
      if Snacks and Snacks.explorer then
        Snacks.explorer({ cwd = vim.g.project_root })
      end
    end)
  end,
})

vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
