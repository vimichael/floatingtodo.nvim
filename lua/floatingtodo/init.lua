local M = {}

local default_opts = {
  target_file = "~/notes/todo.md",
  border = "single",
}

local function expand_path(path)
  if path:sub(1, 1) == "~" then
    return os.getenv("HOME") .. path:sub(2)
  end
  return path
end

local function center_in(outer, inner)
  return (outer - inner) / 2
end

local function win_config(opts)
  local width = math.min(math.floor(vim.o.columns * 0.8), 64)
  local height = math.floor(vim.o.lines * 0.8)

  return {
    relative = "editor",
    width = width,
    height = height,
    col = center_in(vim.o.columns, width),
    row = center_in(vim.o.lines, height),
    border = opts.border
  }
end

local function open_floating_file(opts)
  local expanded_path = expand_path(opts.target_file)

  if vim.fn.filereadable(expanded_path) == 0 then
    vim.notify("todo file does not exist at directory: " .. expanded_path, vim.log.levels.ERROR)
    return
  end

  local buf = vim.fn.bufnr(expanded_path, true)

  if buf == -1 then
    buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_name(buf, expanded_path)
  end

  vim.bo[buf].swapfile = false

  local win = vim.api.nvim_open_win(buf, true, win_config(opts))

  vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
    noremap = true,
    silent = true,
    callback = function()
      if vim.api.nvim_get_option_value("modified", { buf = buf }) then
        vim.notify("save your changes pls", vim.log.levels.WARN)
      else
        vim.api.nvim_win_close(0, true)
      end
    end
  })
end

local function setup_user_commands(opts)
  opts = vim.tbl_deep_extend("force", opts, default_opts)

  vim.api.nvim_create_user_command("Td", function()
    open_floating_file(opts)
  end, {})
end

M.setup = function(opts)
  setup_user_commands(opts)
end

return M
