#!/usr/bin/env lua

-- following option will hide the buffer when it is closed instead of deleting
-- the buffer. This is important to reuse the last terminal buffer
-- IF the option is not set, plugin will open a new terminal every single time
vim.o.hidden = true

require('nvim-terminal').setup({
    window = {
        -- Do `:h :botright` for more information
        -- NOTE: width or height may not be applied in some "pos"
        position = 'botright',
        -- Do `:h split` for more information
        split = 'split',
        -- Width of the terminal
        width = 50,
        -- Height of the terminal
        height = 8,
    },
    -- keymap to toggle open and close terminal window
    toggle_keymap = '<m-=>'
})
terminal = require('nvim-terminal').DefaultTerminal;
vim.keymap.set('t', '<m-=>', '<c-\\><c-N><Cmd>lua terminal:toggle()<cr>', { silent = true })
