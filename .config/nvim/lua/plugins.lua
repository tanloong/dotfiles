#!/usr/bin/env lua
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
        cond = function()
            local bufnr = vim.api.nvim_get_current_buf()
            return not string.find(vim.api.nvim_buf_get_name(bufnr), "interlaced.*%.txt$")
        end,
        config = function()
            require("plugin_config.autosave")
        end
    },
    {
        'https://github.com/neoclide/coc.nvim.git',
        branch = 'release',
        event = { 'InsertEnter', 'CursorHold' },
        -- don't load coc.nvim on "interlaced" filetype
        cond = function()
            local bufnr = vim.api.nvim_get_current_buf()
            return not string.find(vim.api.nvim_buf_get_name(bufnr), "interlaced.*%.txt$")
        end,
        config = function() require('plugin_config.coc') end
    },
    {
        'https://gitee.com/tanloong/vim-surround.git',
        config = function() vim.keymap.set('x', 's', '<Plug>VSurround') end
    },
    {
        'https://github.com/numToStr/Comment.nvim',
        config = function() require('plugin_config.comment') end
    },
    {
        'https://gitee.com/lovealone72/vim-markdown-toc.git',
        ft = { 'markdown' },
        config = function() require('plugin_config.vim_markdown_toc') end
    },
    {
        'https://gitee.com/yaozhijin/vim-table-mode.git',
        ft = { 'markdown' },
        config = function() require('plugin_config.vim_table_mode') end
    },
    {
        'https://gitee.com/tanloong/vim-slime',
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
        config = function() require('plugin_config.hop') end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function() require('plugin_config.nvim_treesitter') end,
        event = 'CursorHold'
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function() require('plugin_config.nvim_treesitter_textobjects') end,
    },
    {
        "https://github.com/SUSTech-data/wildfire.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function() require('plugin_config.wildfire') end,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        event = "CursorHold",
        config = function() require('plugin_config.indent_blankline') end
    },
    {
        'https://gitee.com/tanloong/nvim-align.git',
        event = "CursorHold"
    },
    {
        "akinsho/toggleterm.nvim",
        event = "CursorHold",
        config = function() require('plugin_config.toggleterm') end
    },
    {
        "lmburns/lf.nvim",
        config = function() require('plugin_config.lf_nvim') end,
        dependencies = { "toggleterm.nvim" }
    },
    {
        "nat-418/boole.nvim",
        event = "CursorHold",
        config = function() require('plugin_config.boole_nvim') end,
    },
    {
        'nvimdev/hlsearch.nvim',
        event = 'BufRead',
        config = function()
            require('hlsearch').setup()
        end
    },
    {
        '~/projects/interlaced.nvim',
        cond = function()
            local bufnr = vim.api.nvim_get_current_buf()
            return string.find(vim.api.nvim_buf_get_name(bufnr), "interlaced.*%.txt$") and true or false
        end,
        config = function() require('plugin_config.interlaced_nvim') end,
    },
    { 'kaarmu/typst.vim', ft = { 'typst' } },
}

-- configuration for lazy itself.
local lazy_opts = {
    ui = {
        border = "single",
        title = "Plugin Manager",
        title_pos = "center",
    },
}

require("lazy").setup(plugin_specs, lazy_opts)
