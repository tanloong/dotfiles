#!/usr/bin/env lua

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

vim.cmd([[
    augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
]])

local packer = require('packer')
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float({ border = 'single' })
        end
    }
}

return packer.startup(function(use)
    -- Packer can manage itself
    use { 'https://gitee.com/nvim-plugin/packer.nvim' }
    use { 'https://github.com/neoclide/coc.nvim.git',
        branch = 'release',
        event = { 'InsertEnter', 'CursorHold' },
        config = [[require('plugin_config.coc')]] }
    -- :ASToggle, :ASOn, :ASOff
    -- :help A
    -- utoSave.nvim
    use { 'https://gitee.com/tanloong/auto-save.nvim.git',
        config = [[require('plugin_config.autosave')]] }
    use { 'https://gitee.com/tanloong/vim-surround.git',
        config = [[vim.keymap.set('x', 's', '<Plug>VSurround')]] }
    use { 'https://gitee.com/nvim-plugin/Comment.nvim.git',
        config = [[require('plugin_config.comment')]] }
    use { 'https://gitee.com/lovealone72/vim-markdown-toc.git',
        ft = { 'markdown' },
        config = [[require('plugin_config.vim_markdown_toc')]] }
    use { 'https://gitee.com/yaozhijin/vim-table-mode.git',
        ft = { 'markdown' },
        config = [[require('plugin_config.vim_table_mode')]] }
    use { 'https://gitee.com/tanloong/wildfire.vim.git',
        config = [[require('plugin_config.wildfire')]] }
    use { 'https://gitee.com/tanloong/vim-slime',
        config = [[require('plugin_config.vim_slime')]] }
    use { 'https://gitee.com/mirrors/vimtex.git',
        -- cmd = { 'VimtexCompile' },
        config = [[require('plugin_config.vimtex')]] }
    use { 'https://gitee.com/tanloong/hop.nvim',
        branch = 'match-mappings',
        config = [[require('plugin_config.hop')]] }
    use { 'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = [[require('plugin_config.nvim_treesitter')]],
        event = 'CursorHold' }
    use { 'lukas-reineke/indent-blankline.nvim',
        event = "CursorHold",
        config = [[require('plugin_config.indent_blankline')]] }
    use { 'https://gitee.com/tanloong/nvim-align.git',
        event = "CursorHold" }
    use { "akinsho/toggleterm.nvim",
        event = "CursorHold",
        config = [[require('plugin_config.toggleterm')]] }
    use({
        "lmburns/lf.nvim",
        config = [[require('plugin_config.lf_nvim')]],
        requires = { "toggleterm.nvim" }
    })
end)
