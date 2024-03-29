#!/usr/bin/env lua

local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
    return
end

toggleterm.setup({
    size = 10,
    open_mapping = [[<m-=>]],
    skip_toggle = function(t)
        return t and t.cmd and vim.startswith(t.cmd, "lf ")
    end,
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = false,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "horizontal",
    close_on_exit = false,
    shell = vim.o.shell,
    float_opts = {
        border = "single",
        winblend = 0,
        highlights = {
            border = "Normal",
            background = "Normal",
        },
    },
    highlights = {
        StatusLine = { underline = true, bold = true },
        StatusLineNC = { cterm = "underline" }
    }
})
