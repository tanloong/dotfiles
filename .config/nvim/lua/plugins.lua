#!/usr/bin/env lua

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use {'https://gitee.com/nvim-plugin/packer.nvim'}
    use {'https://gitee.com/ProVim/coc.nvim.git',
         branch='release',
         run = 'yarn install --frozen-lockfile',
         event = {'InsertEnter', 'CursorHold'},
         config = [[require('plugin_config.coc')]]}
    -- :ASToggle, :ASOn, :ASOff
    -- :help A
    -- utoSave.nvim
    use {'https://gitee.com/tanloong/auto-save.nvim.git',
         config = [[require('plugin_config.autosave')]]}
    use {'https://gitee.com/tanloong/vim-surround.git',
        config = [[vim.keymap.set('x', 's', '<Plug>VSurround')]]}
    use {'https://gitee.com/nvim-plugin/Comment.nvim.git',
          config = [[require('plugin_config.comment')]]}
    use {'https://gitee.com/lovealone72/vim-markdown-toc.git', ft={'markdown'},
        config = [[require('plugin_config.vim_markdown_toc')]]}
    use {'https://gitee.com/yaozhijin/vim-table-mode.git', ft={'markdown'},
        config = [[require('plugin_config.vim_table_mode')]]}
    use {'https://gitee.com/tanloong/wildfire.vim.git',
        config = [[require('plugin_config.wildfire')]]}
    use {'https://gitee.com/oy456xd/vim-visual-multi.git',
event='CursorHold'}
    use {'https://gitee.com/tanloong/vim-slime',
        config = [[require('plugin_config.vim_slime')]]} -- needs xdotool
    use {'https://gitee.com/mirrors/vimtex.git',
        config = [[require('plugin_config.vimtex')]]}
    use {'https://gitee.com/ProVim/vim-easymotion.git',
        config = [[require('plugin_config.vim_easymotion')]]}
    -- ch(如，常)对应字母i，sh(如，厦)对应字母u，zh(如，真)对应字母v
    use {'https://gitee.com/tanloong/vim-easymotion-chs.git'}
end)
