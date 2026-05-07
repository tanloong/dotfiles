require('basics')
require('keymaps')
require('plugins')
require('vim._core.ui2').enable()

-- Add border to lsp float window
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "single"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

vim.lsp.enable({"lua", "python"})
