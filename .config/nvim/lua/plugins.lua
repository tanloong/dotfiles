#!/usr/bin/env lua

local keyset = vim.keymap.set
local hl = vim.api.nvim_set_hl

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugin_specs = {
    -- auto-save.nvim
    -- {
    --     'https://gitee.com/tanloong/auto-save.nvim.git',
    --     -- cond = function()
    --     --     local bufnr = vim.api.nvim_get_current_buf()
    --     --     return not string.find(vim.api.nvim_buf_get_name(bufnr), "interlaced.*%.txt$")
    --     -- end,
    --     ft = "python",
    --     event = "VeryLazy",
    --     config = function()
    --         require("plugin_config.autosave")
    --     end
    -- },
    -- CoC
    {
        'https://github.com/neoclide/coc.nvim.git',
        branch = 'release',
        -- don't load coc.nvim on "interlaced" filetype
        cond = function()
            local bufnr = vim.api.nvim_get_current_buf()
            return not string.find(vim.api.nvim_buf_get_name(bufnr), "interlaced.*%.txt$")
        end,
        config = function() require('plugin_config.coc') end
    },
    -- vim-surround
    {
        'https://gitee.com/tanloong/vim-surround.git',
        event = "VeryLazy",
        config = function() vim.keymap.set('x', 's', '<Plug>VSurround') end
    },
    -- Comment
    {
        'https://github.com/numToStr/Comment.nvim',
        event = "VeryLazy",
        config = function() require('plugin_config.comment') end
    },
    -- vim-markdown-toc
    {
        'https://gitee.com/lovealone72/vim-markdown-toc.git',
        ft = { 'markdown' },
        event = "VeryLazy",
        config = function() require('plugin_config.vim_markdown_toc') end
    },
    -- vim-table-mode
    {
        'https://gitee.com/yaozhijin/vim-table-mode.git',
        ft = { 'markdown' },
        event = "VeryLazy",
        config = function() require('plugin_config.vim_table_mode') end
    },
    -- vim-slime
    -- {
    --     'https://gitee.com/tanloong/vim-slime',
    --     event = "VeryLazy",
    --     config = function() require('plugin_config.vim_slime') end
    -- },
    -- Iron
    {
        'Vigemus/iron.nvim',
        config = function()
            local iron = require("iron.core")

            iron.setup {
                config = {
                    -- Whether a repl should be discarded or not
                    scratch_repl = true,
                    repl_definition = {
                        sh     = { command = { "bash" } },
                        python = { command = { "python" } },
                        r      = { command = { "R" } },
                        rmd    = { command = { "R" } },
                        lua    = { command = { "lua" } },
                    },
                    repl_open_cmd = require('iron.view').split.horizontal.botright(0.35)
                },
                keymaps = {
                    send_motion = "<space>sc",
                    visual_send = "<space>sc",
                    send_file = "<space>sf",
                    send_line = "<space>sl",
                    send_until_cursor = "<space>su",
                    send_mark = "<space>sm",
                    mark_motion = "<space>mc",
                    mark_visual = "<space>mc",
                    remove_mark = "<space>md",
                    cr = "<space>s<cr>",
                    interrupt = "<space>s<space>",
                    exit = "<space>sq",
                    clear = "<space>cl",
                },
                highlight = { italic = false },
                ignore_blank_lines = true,
            }
            vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
            vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>')
            vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
            vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
        end
    },
    -- vimtex
    {
        'https://gitee.com/mirrors/vimtex.git',
        -- cmd = { 'VimtexCompile' },
        ft = "tex",
        config = function() require('plugin_config.vimtex') end
    },
    -- hop
    {
        'https://github.com/smoka7/hop.nvim',
        event = "VeryLazy",
        config = function() require('plugin_config.hop') end
    },
    -- tree-sitter
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function() require('plugin_config.nvim_treesitter') end,
        event = "VeryLazy"
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        config = function() require('plugin_config.nvim_treesitter_textobjects') end,
    },
    -- wilefire.nvim
    {
        "https://github.com/SUSTech-data/wildfire.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        config = function() require('plugin_config.wildfire') end,
    },
    -- indent-blankline
    {
        'lukas-reineke/indent-blankline.nvim',
        main = "ibl",
        event = "VeryLazy",
        config = function()
            hl(0, "IblIndent", { ctermbg = 'none', ctermfg = 'darkgray', fg = '#3A3A3A' })
            require("ibl").setup({ scope = { enabled = false } })
        end
    },
    -- nvim-align
    {
        'https://gitee.com/tanloong/nvim-align.git',
        event = "VeryLazy",
    },
    -- toggleterm
    {
        "https://github.com/tanloong/toggleterm.nvim",
        branch = "skip-toggle",
        -- "https://github.com/akinsho/toggleterm.nvim",
        event = "VeryLazy",
        config = function() require('plugin_config.toggleterm') end
    },
    -- lf.nvim
    {
        "https://github.com/tanloong/lf.nvim",
        branch = "fix-wrong-number-of-arguments-to-insert",
        -- "https://github.com/lmburns/lf.nvim",
        config = function() require('plugin_config.lf_nvim') end,
        event = "VeryLazy",
        dependencies = { "toggleterm.nvim" }
    },
    -- neo-tree
    -- {
    --     "nvim-neo-tree/neo-tree.nvim",
    --     branch = "v3.x",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    --         "MunifTanjim/nui.nvim",
    --         -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    --     },
    --     event = "VeryLazy",
    --     config = function()
    --         require("plugin_config.neo_tree")
    --     end,
    -- },
    -- boole
    {
        "nat-418/boole.nvim",
        event = "VeryLazy",
        config = function() require('plugin_config.boole_nvim') end,
    },
    -- hlsearch
    {
        -- 'nvimdev/hlsearch.nvim',
        dir = '/home/tan/projects/hlsearch.nvim/',
        event = "BufRead",
        config = function()
            require('hlsearch').setup()
        end,
        cond = function()
            local bufnr = vim.api.nvim_get_current_buf()
            return not string.find(vim.api.nvim_buf_get_name(bufnr), "interlaced.*%.txt$")
        end,
    },
    -- interlaced
    {
        dir = '~/projects/interlaced.nvim',
        ft = "text",
        config = function()
            opts = {
                mappings = {
                    JoinUp = ",",
                    SplitAtCursor = "d",
                    JoinDown = "D",
                    NavigateDown = "J",
                    NavigateUp = "K",
                },

                setup_mappings_now = false,
            }
            local bufnr = vim.api.nvim_get_current_buf()
            -- automatically enable mappings for *interlaced.txt files, or
            -- otherwise you need to run "MapInterlaced" manually to enable
            -- them
            local is_interlaced_file = (vim.api.nvim_buf_get_name(bufnr)):find("interlaced%.txt$")
            if is_interlaced_file then
                opts["setup_mappings_now"] = true
            end
            require("interlaced").setup(opts)
        end,
    },
    -- typst.vim
    {
        'kaarmu/typst.vim',
        ft = { 'typst' },
        event = "VeryLazy",
        config = function()
            vim.g.typst_auto_open_quickfix = false
            vim.g.typst_syntax_highlight = false
        end,
    },
    -- fcitx.vim
    {
        'https://github.com/lilydjwg/fcitx.vim',
        event = "VeryLazy",
        config = function()
            vim.g.fcitx5_remote = "fcitx5_remote"
        end,
    },
    -- markdown-preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
        event = "VeryLazy",
        config = function() require("plugin_config.markdown_preview") end,
    },
    -- bufferline
    -- {
    --     'akinsho/bufferline.nvim',
    --     version = "*",
    --     dependencies = 'nvim-tree/nvim-web-devicons',
    --     event = "VeryLazy",
    --     config = function()
    --         bufferline = require("bufferline")
    --         bufferline.setup({
    --             options = {
    --                 style_preset = bufferline.style_preset.no_italic,
    --                 indicator = { style = "none" },
    --                 diagnostics = false,
    --                 show_buffer_icons = false,
    --                 show_close_icon = false,
    --                 show_buffer_close_icons = false,
    --                 always_show_bufferline = false,
    --                 separator_style = { '', '' },
    --                 enforce_regular_tabs = false,
    --                 tab_size = 0,
    --                 themable = true,
    --                 show_tab_indicators = false,
    --             },
    --             -- highlights = {
    --             --     -- lua print(vim.inspect(vim.api.nvim_get_hl(0, {name="TabLineFill"})))
    --             --     fill = { bg = '#DDDDDD', ctermbg = 242, underline = true },
    --             --     -- lua print(vim.inspect(vim.api.nvim_get_hl(0, {name="TabLine"})))
    --             --     background = {
    --             --         bg = '#6C6C6C',
    --             --         ctermbg = 242,
    --             --         fg = 'white',
    --             --         ctermfg = 'white',
    --             --         underline = true
    --             --     },
    --             --     pick_selected = { fg = 'white', bg = 'none', italic = false },
    --             --     pick = {
    --             --         bg = '#6C6C6C',
    --             --         ctermbg = 242,
    --             --         fg = 'white',
    --             --         ctermfg = 'white',
    --             --         underline = true,
    --             --         italic = false,
    --             --     },
    --             --     -- lua print(vim.inspect(vim.api.nvim_get_hl(0, {name="TabLineSel"})))
    --             --     tab_selected = { bold = true },
    --             --     -- lua print(vim.inspect(vim.api.nvim_get_hl(0, {name="TabLineSel"})))
    --             --     buffer_selected = { bold = true },
    --             -- }
    --         })
    --         keyset("n", "<right>", "<Cmd>BufferLineCycleNext<CR>", { silent = true })
    --         keyset("n", "<left>", "<Cmd>BufferLineCyclePrev<CR>", { silent = true })
    --         keyset("n", "gH", "<Cmd>BufferLineGoToBuffer 1<CR>", { silent = true })
    --         keyset("n", "gL", "<Cmd>BufferLineGoToBuffer -1<CR>", { silent = true })
    --         keyset("n", "<m-H>", "<Cmd>BufferLineMovePrev<CR>", { silent = true })
    --         keyset("n", "<m-L>", "<Cmd>BufferLineMoveNext<CR>", { silent = true })
    --         keyset("n", "ZP", "<Cmd>BufferLinePick<CR>", { silent = true })
    --         keyset("n", "ZO", "<Cmd>BufferLineCloseOthers<CR>", { silent = true })
    --         keyset("n", "ZL", "<Cmd>BufferLineCloseRight<CR>", { silent = true })
    --         keyset("n", "ZH", "<Cmd>BufferLineCloseLeft<CR>", { silent = true })
    --     end,
    -- },
    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function() require("plugin_config.telescope_nvim") end,
    },

    -- ChatGPT
    -- {
    --     "jackMort/ChatGPT.nvim",
    --     event = "VeryLazy",
    --     config = function()
    --         require("plugin_config.chatgpt")
    --     end,
    --     dependencies = {
    --         "MunifTanjim/nui.nvim",
    --         "nvim-lua/plenary.nvim",
    --         "nvim-telescope/telescope.nvim"
    --     },
    -- },
    {
        -- "robitx/gp.nvim",
        "https://github.com/XXiaoA/gp.nvim",
        config = function()
            require("plugin_config.gp_nvim")
        end,
        event = "VeryLazy",
    },
    {
        -- use this to map jk to search placeholder
        "max397574/better-escape.nvim",
        event = "VeryLazy",
        config = function()
            require("better_escape").setup({
                mapping = { "jk" },
                timeout = vim.o.timeoutlen,
                clear_empty_lines = false,
                -- insert mode mapping
                keys = '<Esc>/<<>><CR>:set nohlsearch<CR>"_c4<right>',
            })
            -- normal mode mapping
            keyset('n', '<SPACE><SPACE>', '/<<>><CR>:set nohlsearch<CR>"_c4<right>')
        end,
    },
    -- diffchar
    {
        "https://github.com/rickhowe/diffchar.vim",
        event = "VeryLazy",
    },
}

-- configuration for lazy itself.
local lazy_opts = {
    ui = {
        border = "single",
        title = "Lazy.nvim",
        title_pos = "center",
    },
}

require("lazy").setup(plugin_specs, lazy_opts)
