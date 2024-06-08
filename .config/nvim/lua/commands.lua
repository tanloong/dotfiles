#!/usr/bin/env lua

local vim_api = vim.api
local c = vim.api.nvim_create_user_command

c('Mv', 'let @s=expand("%")|f <args>|w<bang>|call delete(@s)',
  { force = true, nargs = 1, bang = true, complete = 'file' })
c('Cp', [[let @+ = expand('%:p')]], { force = true })
c('Cd', [[let @+ = expand('%:p:h')]], { force = true })
c('Ct', [[let @+ = expand('%:t')]], { force = true })
-- https://github.com/mfussenegger/dotfiles/blob/a28b73904fe3e57459c3f32e6fac8bba95133c62/vim/dot-config/nvim/commands.lua#L3C1-L11C22
c("Rm", function(args)
  local bufnr = vim_api.nvim_get_current_buf()
  local fname = vim_api.nvim_buf_get_name(bufnr)
  if vim.bo[bufnr].buftype == "" then
    local ok, err = os.remove(fname)
    assert(args.bang or ok, err)
  end
  vim_api.nvim_buf_delete(bufnr, { force = args.bang })
end, { bang = true })
c("Lua", function(args)
  local srcbuf = vim_api.nvim_get_current_buf()
  vim.cmd.split()
  local bufnr = vim_api.nvim_create_buf(true, true)
  vim_api.nvim_buf_set_name(bufnr, "lua://" .. tostring(bufnr))
  if args.range ~= 0 then
    local lines = vim_api.nvim_buf_get_lines(srcbuf, args.line1 - 1, args.line2, true)
    local indent = math.huge
    for _, line in ipairs(lines) do
      indent = math.min(line:find("[^ ]") or math.huge, indent)
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
  vim.bo[bufnr].filetype = "lua"
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
  vim_api.nvim_set_current_buf(bufnr)
  vim_api.nvim_create_autocmd("BufWriteCmd", {
    buffer = bufnr,
    callback = function(write_args)
      vim.bo[write_args.buf].modified = false
      execlua(write_args.buf)
    end,
  })
end, { range = "%" })
