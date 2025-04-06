#!/usr/bin/env lua

local vim_api = vim.api
local c = vim.api.nvim_create_user_command

c("Mv", function(a)
  local bufnr = vim_api.nvim_get_current_buf()
  local oldpath = vim_api.nvim_buf_get_name(bufnr)
  vim.cmd(string.format("saveas%s %s", a.bang and "!" or "", a.args))
  vim.cmd [[bd #]]
  local ok, err = os.remove(oldpath)
  assert(a.bang or ok, err)
end, { force = true, nargs = 1, bang = true, complete = "file" })
c("Yp", [[let @+ = expand('%:p')]], { force = true,desc = "Yank full path" })
c("Yd", [[let @+ = expand('%:p:h')]], { force = true, desc = "Yank dirname" })
c("Yb", [[let @+ = expand('%:t')]], { force = true, desc = "Yank basename" })
-- https://github.com/mfussenegger/dotfiles/blob/a28b73904fe3e57459c3f32e6fac8bba95133c62/vim/dot-config/nvim/commands.lua#L3C1-L11C22
c("Rm", function(a)
  local bufnr = vim_api.nvim_get_current_buf()
  local fname = vim_api.nvim_buf_get_name(bufnr)
  vim_api.nvim_buf_delete(bufnr, { force = a.bang })
  local yes = vim.fn.confirm("The deletion can't be undone, are you sure?", "&Yes\n&No\n&Cancel")
  if yes == 1 then
    local ok, err = os.remove(fname)
    assert(a.bang or ok, err)
  end
end, { bang = true })

local function execlua(buf)
  local lines = vim_api.nvim_buf_get_lines(buf, 0, -1, true)
  local code = table.concat(lines, "\n")
  local fn, err = loadstring(code)
  if fn then
    local result = fn()
    if result then
      vim.print(result)
    end
  elseif err then
    vim.notify(err, vim.log.levels.WARN)
  end
end
local function execpython(buf)
  local lines = vim_api.nvim_buf_get_lines(buf, 0, -1, true)
  local code = table.concat(lines, "\n")
  local handle
  local stdout = vim.uv.new_pipe(false)
  if stdout == nil then return end
  local stderr = vim.uv.new_pipe(false)
  if stderr == nil then return end
  local stdout_data = ""
  local stderr_data = ""

  local on_exit = vim.schedule_wrap(function(code, signal)
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    if handle and not handle:is_closing() then handle:close() end
    if stderr_data ~= "" then
      vim.notify(stderr_data); return
    end
    if stdout_data ~= "" then vim.notify(stdout_data) end
  end)

  handle, pid = vim.uv.spawn("python", {
    args = { "-c", code },
    stdio = { nil, stdout, stderr },
    hide = true,
    detached = true
  }, on_exit)

  vim.uv.read_start(stdout, function(err, data)
    if err then vim.print(err) end
    if data then stdout_data = data:gsub("^%s+", ""):gsub("%s+$", "") end
  end)
  vim.uv.read_start(stderr, function(err, data)
    if err then vim.print(err) end
    if data then stderr_data = data:gsub("^%s+", ""):gsub("%s+$", "") end
  end)
end
local function execc(buf)
  local lines = vim_api.nvim_buf_get_lines(buf, 0, -1, true)
  local code = table.concat(lines, "\n")
  local executable = vim.fn.tempname()
  local filename = executable .. ".c"

  -- Write the C code to a temporary file
  local file = io.open(filename, "w")
  if file == nil then return end
  file:write(code)
  file:close()

  local handle
  local stdout = vim.uv.new_pipe(false)
  if stdout == nil then return end
  local stderr = vim.uv.new_pipe(false)
  if stderr == nil then return end
  local stdout_data = ""
  local stderr_data = ""

  local on_exit = vim.schedule_wrap(function(code, signal)
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    if handle and not handle:is_closing() then handle:close() end
    if stderr_data ~= "" then
      vim.notify("Compile Error: " .. stderr_data, vim.log.levels.ERROR); return
    end
    if stdout_data ~= "" then vim.notify(stdout_data) end
  end)

  -- Compile the C code
  handle, pid = vim.uv.spawn("gcc", {
    args = { filename, "-o", executable },
    stdio = { nil, stdout, stderr },
    hide = true,
    detached = true
  }, on_exit)

  vim.uv.read_start(stdout, function(err, data)
    if err then vim.print(err) end
    if data then stdout_data = data:gsub("^%s+", ""):gsub("%s+$", "") end
  end)
  vim.uv.read_start(stderr, function(err, data)
    if err then vim.print(err) end
    if data then stderr_data = data:gsub("^%s+", ""):gsub("%s+$", "") end
  end)

  local run_handle
  local run_stdout = vim.uv.new_pipe(false)
  if run_stdout == nil then return end
  local run_stderr = vim.uv.new_pipe(false)
  if run_stderr == nil then return end
  local run_stdout_data = ""
  local run_stderr_data = ""

  local run_on_exit = vim.schedule_wrap(function(code, signal)
    run_stdout:read_stop()
    run_stderr:read_stop()
    run_stdout:close()
    run_stderr:close()
    if run_handle and not run_handle:is_closing() then run_handle:close() end
    if run_stderr_data ~= "" then
      vim.notify("Run Error: " .. run_stderr_data, vim.log.levels.ERROR); return
    end
    if run_stdout_data ~= "" then vim.notify(run_stdout_data) end
  end)

  run_handle, run_pid = vim.uv.spawn(executable, {
    stdio = { nil, run_stdout, run_stderr },
    hide = true,
    detached = true
  }, run_on_exit)

  vim.uv.read_start(run_stdout, function(err, data)
    if err then vim.print(err) end
    if data then run_stdout_data = data:gsub("^%s+", ""):gsub("%s+$", "") end
  end)

  vim.uv.read_start(run_stderr, function(err, data)
    if err then vim.print(err) end
    if data then run_stderr_data = data:gsub("^%s+", ""):gsub("%s+$", "") end
  end)
end
local function create_scratch(args, ft, ext, execfunc)
  local srcbuf = vim_api.nvim_get_current_buf()
  vim.cmd.split()
  local bufnr = vim_api.nvim_create_buf(true, true)
  vim_api.nvim_buf_set_name(bufnr, "scratch" .. tostring(bufnr) .. ext)
  if args.range ~= 0 then
    local lines = vim_api.nvim_buf_get_lines(srcbuf, args.line1 - 1, args.line2, true)
    local indent = math.huge
    for _, line in ipairs(lines) do
      indent = math.min(line:find "[^ ]" or math.huge, indent)
    end
    if indent ~= math.huge and indent > 0 then
      for i, line in ipairs(lines) do
        lines[i] = line:sub(indent)
      end
    end
    vim_api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
    vim.bo[bufnr].modified = false
  end
  vim.bo[bufnr].buftype = "acwrite"
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].filetype = ft
  vim_api.nvim_set_current_buf(bufnr)
  vim_api.nvim_create_autocmd("BufWriteCmd", {
    buffer = bufnr,
    callback = function(write_args)
      vim.bo[write_args.buf].modified = false
      execfunc(write_args.buf)
    end,
  })
end
c("Lua", function(args) create_scratch(args, "lua", ".lua", execlua) end, { range = "%" })
c("Py", function(args) create_scratch(args, "python", ".py", execpython) end, { range = "%" })
c("C", function(args) create_scratch(args, "c", ".c", execc) end, { range = "%" })
