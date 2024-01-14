#!/usr/bin/env lua

local hop = require('hop')
hop.setup({ match_mappings = { 'zh', 'zh_sc' } })
vim.keymap.set({ 'n', 'v', 'o' }, 'ff', function()
    hop.hint_char1()
end, { remap = true })

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
