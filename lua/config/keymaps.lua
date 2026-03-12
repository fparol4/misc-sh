local function yank_relative_path_with_lines()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    return
  end

  local base = vim.g.project_root or vim.fn.getcwd()
  local rel = vim.fs.relpath(base, path) or vim.fn.fnamemodify(path, ":.")
  local start_line = vim.fn.getpos("v")[2]
  local end_line = vim.fn.getcurpos()[2]

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local value = string.format("%s:%d-%d", rel, start_line, end_line)
  vim.fn.setreg("+", value)
  vim.fn.setreg('"', value)
  vim.notify("Yanked " .. value)
end

local function persist_colorscheme(picker, item)
  if not item then
    return
  end

  local colorscheme = item.text
  local path = vim.fn.stdpath("config") .. "/lua/config/colorscheme.lua"

  vim.fn.writefile({ string.format('return %q', colorscheme) }, path)
  package.loaded["config.colorscheme"] = nil
  picker.preview.state.colorscheme = nil
  picker:close()

  vim.schedule(function()
    vim.cmd.colorscheme(colorscheme)
    vim.notify("Saved colorscheme: " .. colorscheme)
  end)
end

local function curated_colorschemes()
  local curated = require("lua.resources.colorschemes")
  local items = vim.tbl_map(function(colorscheme)
    return { text = colorscheme }
  end, curated)

  Snacks.picker.pick({
    title = "Colorschemes",
    items = items,
    format = "text",
    preview = "colorscheme",
    layout = { preset = "vertical" },
    actions = {
      confirm = persist_colorscheme,
    },
  })
end

local function all_colorschemes()
  Snacks.picker.colorschemes({ confirm = persist_colorscheme })
end

vim.keymap.set("n", "<leader>e", function()
  Snacks.explorer({ cwd = vim.g.project_root })
end, { desc = "File Explorer (Root)" })

vim.keymap.set("n", "<leader><leader>", function()
  Snacks.picker.files({ cwd = vim.g.project_root })
end, { desc = "Find Files (Root)" })

vim.keymap.set("n", "<leader>uC", function()
  curated_colorschemes()
end, { desc = "Colorschemes" })

vim.keymap.set("n", "<leader>uX", function()
  all_colorschemes()
end, { desc = "All Colorschemes" })

vim.keymap.set("n", "<X1Mouse>", "<C-o>", { desc = "Jump Back" })
vim.keymap.set("n", "<X2Mouse>", "<C-i>", { desc = "Jump Forward" })

vim.keymap.set("x", "<leader>l", yank_relative_path_with_lines, { desc = "Yank Relative" })
