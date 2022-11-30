#!/usr/bin/env lua
-- Selects the next closest text object.
vim.keymap.set({ 'n', 'v', 'o' }, '=', '<Plug>(wildfire-fuel)')
-- Selects the previous closest text object.
vim.keymap.set('v', '-', '<Plug>(wildfire-water)')
vim.g['wildfire_objects'] = { "i'", "a'", 'i"', 'a"', "i)", "a)", "i]", "a]", "i}", "a}", "ip", "it", "iW", "i`" }
