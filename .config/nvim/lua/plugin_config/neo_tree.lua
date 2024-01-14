#!/usr/bin/env lua

local keyset = vim.keymap.set

toggle_keystroke = "tt"
keyset("n", toggle_keystroke, "<Cmd>Neotree toggle<CR>")
require("neo-tree").setup({
    source = { "filesystem", "buffers" },
    enable_git_status = false,
    close_if_last_window = true,
    popup_border_style = "single",
    default_component_configs = {
        container = { enable_character_fade = false, },
        name = { trailing_slash = true, use_git_status_colors = false },
        file_size = { enabled = false },
        last_modified = { enabled = false },
        icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
        },
    },
    window = {
        width = 30,
        mappings = {
            ["l"]              = "open",
            ["<leftrelease>"]  = "open",
            ["<c-t>"]          = "open_tabnew",
            ["h"]              = "close_node",
            ["zM"]             = "close_all_nodes",
            ["dD"]             = "delete",
            [toggle_keystroke] = "close_window",
            ["q"]              = "close_window",
            ["s"]              = "none",
            ["S"]              = "none",
            ["C"]              = "none",
            ["H"]              = "none",
            ["gu"]             = "none",
            ["ga"]             = "none",
            ["gr"]             = "none",
            ["gc"]             = "none",
            ["gp"]             = "none",
            ["gg"]             = "none",
            ["t"]              = "none",
            ["w"]              = "none",
            ["A"]              = "none",
            ["d"]              = "none",
            ["r"]              = "none",
            ["y"]              = "none",
            ["x"]              = "none",
            ["p"]              = "none",
            ["c"]              = "none",
            ["m"]              = "none",
        }
    },
    filesystem = {
        follow_current_file = { enabled = true },
        components = {
            icon = function(config, node, state)
                if node.type == 'file' then
                    return {
                        text = "  ",
                        highlight = config.highlight,
                    }
                end
                return require('neo-tree.sources.common.components').icon(config, node, state)
            end,

        },
        window = {
            mappings = {
                ["<esc>"] = "clear_filter",
                ["zh"] = "toggle_hidden",
            }
        }
    },
})
