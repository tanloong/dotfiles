#!/usr/bin/env lua

local hop = require('hop')
hop.setup({
    keys = 'asdghklqwertyuiopzxcvbnmfj;',
    match_mappings = {'zh', 'zh_huma'}
})
vim.keymap.set({ 'n', 'v', 'o' }, 'f', "<Cmd>HopChar1MW<CR>")

-- local directions = require('hop.hint').HintDirection
-- vim.keymap.set({'n','v','o'}, 'f', function()
--   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false })
-- end, {remap=true})
-- vim.keymap.set({'n','v','o'}, 'F', function()
--   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false })
-- end, {remap=true})
-- vim.keymap.set({'n','v','o'}, 't', function()
--   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false, hint_offset = -1 })
-- end, {remap=true})
-- vim.keymap.set({'n','v','o'}, 'T', function()
--   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false, hint_offset = 1 })
-- end, {remap=true})
