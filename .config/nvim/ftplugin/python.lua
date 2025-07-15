#!/usr/bin/env lua

local api = vim.api
local c = vim.api.nvim_create_user_command

------------------------------- Python unittest --------------------------------
local function find_nearest_class(bufnr, start_line)
  for l = start_line, 1, -1 do
    local line = api.nvim_buf_get_lines(bufnr, l - 1, l, false)[1]
    local class_name = line:match('^%s*class%s+([%w_]+)')
    if class_name then return class_name end
  end
  return nil
end
local function find_nearest_function(bufnr, start_line)
  for l = start_line, 1, -1 do
    local line = api.nvim_buf_get_lines(bufnr, l - 1, l, false)[1]
    local func_name = line:match('^%s*def%s+([%w_]+)')
    if func_name then return func_name end
  end
  return nil
end
function copy_test_path()
  local bufnr = api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  if ft ~= 'python' then
    vim.notify("':Yu' 命令只能在 Python 文件中使用", vim.log.levels.WARN)
    return
  end
  local row = api.nvim_win_get_cursor(0)[1]
  local filepath = api.nvim_buf_get_name(bufnr)
  if filepath == '' then
    vim.notify("缓冲区没有关联文件", vim.log.levels.WARN)
    return
  end

  local cwd = vim.uv.cwd()
  local rel_path = filepath:gsub('^' .. cwd .. '/', '')
  local module_path = rel_path:gsub('.py$', ''):gsub('/', '.')
  local class_name = find_nearest_class(bufnr, row)
  local func_name = find_nearest_function(bufnr, row)

  if not class_name and not func_name then
    vim.notify("未找到类或函数定义", vim.log.levels.WARN)
    return
  end
  local test_path = (("%s.%s.%s"):format(module_path, class_name, func_name))
  local interpreter = vim.fs.joinpath(cwd, "python")
  if not vim.fn.executable(interpreter) then interpreter = "python" end
  local command = (("%s -m unittest %s<CR>"):format(interpreter, test_path))
  vim.cmd("botright split term://fish | startinsert")
  api.nvim_input(command)
  api.nvim_input("<c-\\><c-n>G")
end
c('Pt', copy_test_path, {
  desc = 'Run python unittest on where cursor at (python -m unittest module.path.ClassName.test_name)'
})
