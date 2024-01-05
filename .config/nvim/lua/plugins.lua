#!/usr/bin/env lua

local keyset = vim.keymap.set
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
    {
        'https://gitee.com/tanloong/auto-save.nvim.git',
        -- cond = function()
        --     local bufnr = vim.api.nvim_get_current_buf()
        --     return not string.find(vim.api.nvim_buf_get_name(bufnr), "interlaced.*%.txt$")
        -- end,
        ft = "python",
        event = "VeryLazy",
        config = function()
            require("plugin_config.autosave")
        end
    },
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
    {
        'https://gitee.com/tanloong/vim-surround.git',
        event = "VeryLazy",
        config = function() vim.keymap.set('x', 's', '<Plug>VSurround') end
    },
    {
        'https://github.com/numToStr/Comment.nvim',
        event = "VeryLazy",
        config = function() require('plugin_config.comment') end
    },
    {
        'https://gitee.com/lovealone72/vim-markdown-toc.git',
        ft = { 'markdown' },
        event = "VeryLazy",
        config = function() require('plugin_config.vim_markdown_toc') end
    },
    {
        'https://gitee.com/yaozhijin/vim-table-mode.git',
        ft = { 'markdown' },
        event = "VeryLazy",
        config = function() require('plugin_config.vim_table_mode') end
    },
    {
        'https://gitee.com/tanloong/vim-slime',
        event = "VeryLazy",
        config = function() require('plugin_config.vim_slime') end
    },
    {
        'https://gitee.com/mirrors/vimtex.git',
        -- cmd = { 'VimtexCompile' },
        config = function() require('plugin_config.vimtex') end
    },
    {
        'https://gitee.com/tanloong/hop.nvim',
        branch = 'match-mappings',
        event = "VeryLazy",
        config = function() require('plugin_config.hop') end
    },
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
    {
        "https://github.com/SUSTech-data/wildfire.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        config = function() require('plugin_config.wildfire') end,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        tag = "v2.20.8",
        event = "VeryLazy",
        config = function() require('plugin_config.indent_blankline') end
    },
    {
        'https://gitee.com/tanloong/nvim-align.git',
        event = "VeryLazy",
    },
    {
        "akinsho/toggleterm.nvim",
        event = "VeryLazy",
        config = function() require('plugin_config.toggleterm') end
    },
    {
        "lmburns/lf.nvim",
        config = function() require('plugin_config.lf_nvim') end,
        event = "VeryLazy",
        dependencies = { "toggleterm.nvim" }
    },
    {
        "nat-418/boole.nvim",
        event = "VeryLazy",
        config = function() require('plugin_config.boole_nvim') end,
    },
    -- {
    --     -- 'nvimdev/hlsearch.nvim',
    --     dir = '/home/tan/software/hlsearch.nvim/',
    --     event = "BufRead",
    --     config = function()
    --         require('hlsearch').setup()
    --     end,
    --     cond = function()
    --         local bufnr = vim.api.nvim_get_current_buf()
    --         return not string.find(vim.api.nvim_buf_get_name(bufnr), "interlaced.*%.txt$")
    --     end,
    -- },
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
    {
        'kaarmu/typst.vim',
        ft = { 'typst' }
    },
    {
        'https://github.com/lilydjwg/fcitx.vim',
        event = "VeryLazy"
    },
    -- {
    --     "https://github.com/askfiy/visual_studio_code",
    --     priority = 100,
    --     config = function()
    --         require("visual_studio_code").setup({ -- {{{
    --             -- `dark` or `light`
    --             mode = "dark",
    --             -- Whether to load all color schemes
    --             preset = true,
    --             -- Whether to enable background transparency
    --             transparent = false,
    --             -- Whether to apply the adapted plugin
    --             expands = {
    --                 hop = true,
    --                 dbui = true,
    --                 lazy = true,
    --                 aerial = true,
    --                 null_ls = true,
    --                 nvim_cmp = true,
    --                 gitsigns = true,
    --                 which_key = true,
    --                 nvim_tree = true,
    --                 lspconfig = true,
    --                 telescope = true,
    --                 bufferline = true,
    --                 nvim_navic = true,
    --                 nvim_notify = true,
    --                 vim_illuminate = true,
    --                 nvim_treesitter = true,
    --                 nvim_ts_rainbow = true,
    --                 nvim_scrollview = true,
    --                 nvim_ts_rainbow2 = true,
    --                 indent_blankline = true,
    --                 vim_visual_multi = true,
    --             },
    --             hooks = {
    --                 before = function(conf, colors, utils) end,
    --                 after = function(conf, colors, utils) end,
    --             },
    --         }) -- }}}
    --         vim.opt.termguicolors = true
    --         vim.cmd([[colorscheme visual_studio_code]])
    --     end,
    -- },
    -- install without yarn or npm
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
        event = "VeryLazy",
        config = function() require("plugin_config.markdown_preview") end,
    },
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        event = "VeryLazy",
        config = function()
            bufferline = require("bufferline")
            bufferline.setup({
                options = {
                    style_preset = bufferline.style_preset.no_italic,
                    indicator = { style = "none" },
                    diagnostics = false,
                    show_buffer_icons = false,
                    show_buffer_close_icons = false,
                    always_show_bufferline = false,
                    separator_style = { '', '' },
                    enforce_regular_tabs = false,
                    tab_size = 0,
                },
                highlights = {
                    -- lua print(vim.inspect(vim.api.nvim_get_hl(0, {name = "TabLineFill"})))
                    fill = { ctermbg = 242, underline = true },
                    -- lua print(vim.inspect(vim.api.nvim_get_hl(0, {name = "TabLine"})))
                    background = {
                        ctermbg = 242,
                        ctermfg = 15,
                        underline = true
                    },
                    -- lua print(vim.inspect(vim.api.nvim_get_hl(0, {name = "TabLineSel"})))
                    tab_selected = { bold = true },
                    -- lua print(vim.inspect(vim.api.nvim_get_hl(0, {name = "TabLineSel"})))
                    buffer_selected = { bold = true },
                }
            })
            keyset("n", "gl", "<Cmd>BufferLineCycleNext<CR>", { silent = true })
            keyset("n", "gh", "<Cmd>BufferLineCyclePrev<CR>", { silent = true })
            keyset("n", "gH", "<Cmd>BufferLineGoToBuffer 1<CR>", { silent = true })
            keyset("n", "gL", "<Cmd>BufferLineGoToBuffer -1<CR>", { silent = true })
            keyset("n", "<m-H>", "<Cmd>BufferLineMovePrev<CR>", { silent = true })
            keyset("n", "<m-L>", "<Cmd>BufferLineMoveNext<CR>", { silent = true })
            keyset("n", "<leader><leader>", "<Cmd>BufferLinePick<CR>", { silent = true })
        end,
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
