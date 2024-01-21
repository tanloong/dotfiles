#!/usr/bin/env lua

local keyset = vim.keymap.set

-- https://github.com/jackMort/ChatGPT.nvim/blob/main/lua/chatgpt/config.lua
require("chatgpt").setup({
    chat = {
        border = { style = "single", },
        keymaps = {
            close = "<C-c>",
            yank_last = "<C-y>",
            yank_last_code = "<C-k>",
            scroll_up = "<C-u>",
            scroll_down = "<C-d>",
            new_session = "<C-n>",
            cycle_windows = "<Tab>",
            cycle_modes = "<C-f>",
            next_message = "<C-j>",
            prev_message = "<C-k>",
            select_session = "<Space>",
            rename_session = "cw",
            delete_session = "dd",
            draft_message = "<C-r>",
            edit_message = "e",
            delete_message = "dd",
            toggle_settings = "<C-o>",
            toggle_sessions = "<C-p>",
            toggle_help = "<C-h>",
            toggle_message_role = "<C-r>",
            toggle_system_role_open = "<C-s>",
            stop_generating = "<C-x>",
        }
    },
    popup_window = { border = { style = "single", }, },
    system_window = { border = { style = "single", }, },
    popup_input = { border = { style = "single", }, },
    settings_window = { border = { style = "single", }, },
    help_window = { border = { style = "single", }, },
    actions_paths = {
        vim.fn.expand("~/.config/nvim/lua/plugin_config/chatgpt-actions.json"),
    },
})
keyset("n", "<bar>", "<Cmd>ChatGPT<CR>")
keyset("v", "<bar>", "<Cmd>ChatGPTEditWithInstructions<CR>")
keyset({ "n", "v" }, "<c-bar>", ":ChatGPTRun<space>")
keyset("n", "<c-s-bar>", "<Cmd>ChatGPTActAs<CR>")
keyset("v", "<F5>", "<Cmd>ChatGPTRun inline<CR>")
