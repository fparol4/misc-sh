local M = {}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO)
end

local function get_register_text()
  local reg = vim.v.register
  if not reg or reg == "" then
    reg = '"'
  end

  local lines = vim.fn.getreg(reg, 1, true)
  if type(lines) ~= "table" or vim.tbl_isempty(lines) then
    return nil
  end

  return table.concat(lines, "\n")
end

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function resolve_file_path(raw)
  if not raw or raw == "" then
    return nil
  end

  local content = trim(raw)
  if content == "" or content:find("\n") then
    return nil
  end

  local expanded = vim.fn.expand(content)
  local normalized = vim.fs.normalize(expanded)

  if vim.fn.filereadable(normalized) == 1 then
    return normalized
  end

  if vim.fn.filereadable(expanded) == 1 then
    return expanded
  end

  return nil
end

local function destination_dir()
  local buf_path = vim.api.nvim_buf_get_name(0)
  if buf_path ~= "" then
    return vim.fn.fnamemodify(buf_path, ":p:h")
  end
  return vim.g.project_root or vim.fn.getcwd()
end

local function unique_destination_path(dest_dir, basename)
  local target = vim.fs.joinpath(dest_dir, basename)
  if vim.loop.fs_stat(target) == nil then
    return target
  end

  local stem = basename
  local ext = ""
  local first_dot = basename:find("%.[^%.]*$")
  if first_dot then
    stem = basename:sub(1, first_dot - 1)
    ext = basename:sub(first_dot)
  end

  local i = 1
  while true do
    local candidate = vim.fs.joinpath(dest_dir, string.format("%s-%d%s", stem, i, ext))
    if vim.loop.fs_stat(candidate) == nil then
      return candidate
    end
    i = i + 1
  end
end

local function copy_file(src, dst)
  local src_fd = vim.loop.fs_open(src, "r", 420)
  if not src_fd then
    return false
  end

  local stat = vim.loop.fs_fstat(src_fd)
  if not stat then
    vim.loop.fs_close(src_fd)
    return false
  end

  local data = vim.loop.fs_read(src_fd, stat.size, 0)
  vim.loop.fs_close(src_fd)
  if not data then
    return false
  end

  local dst_fd = vim.loop.fs_open(dst, "w", stat.mode)
  if not dst_fd then
    return false
  end

  local ok = vim.loop.fs_write(dst_fd, data, 0)
  vim.loop.fs_close(dst_fd)
  return ok ~= nil
end

local function build_markdown_link(dst)
  local base = destination_dir()
  local rel = vim.fs.relpath(base, dst) or vim.fn.fnamemodify(dst, ":.")
  local name = vim.fs.basename(dst)
  return string.format("[%s](<%s>)", name, rel)
end

local function insert_text(text)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local before = line:sub(1, col)
  local after = line:sub(col + 1)
  vim.api.nvim_set_current_line(before .. text .. after)
  vim.api.nvim_win_set_cursor(0, { row, col + #text })
end

function M.smart_paste()
  local raw = get_register_text()
  local src = resolve_file_path(raw)

  if not src then
    vim.cmd.normal({ args = { "p" }, bang = true })
    return
  end

  local dest_dir = destination_dir()
  local basename = vim.fs.basename(src)
  local dst = unique_destination_path(dest_dir, basename)

  local ok = copy_file(src, dst)
  if not ok then
    notify("Smart paste: failed to copy file, using normal paste", vim.log.levels.WARN)
    vim.cmd.normal({ args = { "p" }, bang = true })
    return
  end

  local link = build_markdown_link(dst)
  insert_text(link)
  notify(string.format("Smart paste: copied %s", vim.fs.basename(dst)))
end

return M
