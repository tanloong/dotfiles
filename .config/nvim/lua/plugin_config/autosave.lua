#!/usr/bin/env lua
require('auto-save').setup(
    {
        enabled = true,
        execution_message = {
            message = "",
            -- message = function() -- message to print on save
            --     return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
            -- end,
            dim = 0,                  -- dim the color of `message`
            cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`.
        },
        trigger_events = { "InsertLeave", "TextChanged" },
        write_all_buffers = false,
        -- write all buffers when the current one meets `condition`
        debounce_delay = 135,
        -- saves the file at most every `debounce_delay` milliseconds
    }
)
