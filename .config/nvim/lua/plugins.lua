#!/usr/bin/env lua

local keyset = vim.keymap.set
local hl = vim.api.nvim_set_hl

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
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
    "https://github.com/neoclide/coc.nvim.git",
    enabled = true,
    branch = "release",
    event = "VeryLazy",
    -- don't load coc.nvim on "interlaced" filetype
    cond = function()
      local bufnr = vim.api.nvim_get_current_buf()
      return not string.find(vim.api.nvim_buf_get_name(bufnr), "interlaced.*%.txt$")
    end,
    config = function() require "plugin_config.coc" end
  },
  -- vim-surround
  {
    "https://gitee.com/tanloong/vim-surround.git",
    event = "VeryLazy",
    config = function() vim.keymap.set("x", "s", "<Plug>VSurround") end
  },
  -- Comment
  {
    "https://github.com/numToStr/Comment.nvim",
    enabled = vim.fn.has "nvim-0.10" == 0,
    event = "VeryLazy",
    config = function() require "plugin_config.comment" end
  },
  -- vim-markdown-toc
  {
    "https://github.com/mzlogin/vim-markdown-toc",
    ft = { "markdown" },
    event = "VeryLazy",
    config = function() require "plugin_config.vim_markdown_toc" end
  },
  -- vim-table-mode
  {
    "https://gitee.com/yaozhijin/vim-table-mode.git",
    enabled = false,
    ft = { "markdown" },
    event = "VeryLazy",
    config = function() require "plugin_config.vim_table_mode" end
  },
  -- vim-slime
  -- {
  --     'https://gitee.com/tanloong/vim-slime',
  --     event = "VeryLazy",
  --     config = function() require('plugin_config.vim_slime') end
  -- },
  -- Iron
  {
    "Vigemus/iron.nvim",
    config = function()
      local iron = require "iron.core"

      iron.setup {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          repl_definition = {
            sh = { command = { "bash" } },
            python = { command = { "python" } },
            lua = { command = { "lua" } },
            php = { command = { "php", "-a" } },
            r = { command = { "R" } },
            rmd = { command = { "R" } },
          },
          repl_open_cmd = require "iron.view".split.horizontal.botright(0.35)
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
      vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
      vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
      vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
      vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
    end
  },
  -- vimtex
  {
    "https://gitee.com/mirrors/vimtex.git",
    -- cmd = { 'VimtexCompile' },
    ft = "tex",
    config = function() require "plugin_config.vimtex" end
  },
  -- hop
  {
    "https://github.com/smoka7/hop.nvim",
    event = "VeryLazy",
    config = function() require "plugin_config.hop" end
  },
  -- tree-sitter
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function() require "plugin_config.nvim_treesitter" end,
    event = "VeryLazy"
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    config = function() require "plugin_config.nvim_treesitter_textobjects" end,
  },
  -- wildfire.nvim
  {
    "https://github.com/SUSTech-data/wildfire.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    config = function() require "plugin_config.wildfire" end,
  },
  -- indent-blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    version = vim.fn.has "nvim-0.10" == 1 and "v3.6.0" or "v3.5.4",
    event = "VeryLazy",
    config = function()
      hl(0, "IblIndent", { ctermbg = "none", ctermfg = "darkgray", fg = "#3A3A3A" })
      require "ibl".setup { scope = { enabled = false } }
    end
  },
  -- nvim-align
  {
    "https://gitee.com/tanloong/nvim-align.git",
    event = "VeryLazy",
  },
  -- toggleterm
  {
    "https://github.com/tanloong/toggleterm.nvim",
    branch = "skip-toggle",
    -- "https://github.com/akinsho/toggleterm.nvim",
    event = "VeryLazy",
    config = function() require "plugin_config.toggleterm" end
  },
  -- lf.nvim
  {
    "https://github.com/tanloong/lf.nvim",
    enabled = true,
    branch = "fix-wrong-number-of-arguments-to-insert",
    -- "https://github.com/lmburns/lf.nvim",
    config = function() require "plugin_config.lf_nvim" end,
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
    config = function() require "plugin_config.boole_nvim" end,
  },
  -- hlsearch
  {
    -- 'nvimdev/hlsearch.nvim',
    dir = "/home/tan/projects/hlsearch.nvim/",
    enabled = false,
    event = "BufRead",
    config = function()
      require "hlsearch".setup()
    end,
    cond = function()
      local bufnr = vim.api.nvim_get_current_buf()
      return not string.find(vim.api.nvim_buf_get_name(bufnr), "interlaced.*%.txt$")
    end,
  },
  -- interlaced
  {
    dir = "~/projects/interlaced.nvim",
    ft = "text",
    branch = "dev",
    event = "VeryLazy",
    config = function()
      local mt = require "interlaced.match"
      local rpst = require "interlaced.reposition"
      local it = require "interlaced"
      local opt = { noremap = true, buffer = true, nowait = true }
      opts = {
        keymaps = {
          { "n", ",", rpst.cmd.PushUp, opt },
          { "n", "<", rpst.cmd.PushUpPair, opt },
          { "n", "e", rpst.cmd.PushUpLeftPart, opt },
          { "n", ".", rpst.cmd.PullBelow, opt },
          { "n", ">", rpst.cmd.PullBelowPair, opt },
          { "n", "d", rpst.cmd.PushDownRightPart, opt },
          { "n", "D", rpst.cmd.PushDown, opt },
          { "n", "s", rpst.cmd.LeaveAlone, opt },
          { "n", "[e", rpst.cmd.SwapWithAbove, opt },
          { "n", "]e", rpst.cmd.SwapWithBelow, opt },
          { "n", "u", rpst.cmd.Undo, opt },
          { "n", "<C-r>", rpst.cmd.Redo, opt },
          { "n", "J", rpst.cmd.NavigateDown, opt },
          { "n", "K", rpst.cmd.NavigateUp, opt },
          { "n", "md", it.cmd.Dump, opt },
          { "n", "ml", it.cmd.Load, opt },
          { "n", "gn", rpst.cmd.NextUnaligned, opt },
          { "n", "gN", rpst.cmd.PrevUnaligned, opt },
          { "n", "mt", mt.cmd.MatchToggle, opt },
          { "n", "m;", mt.cmd.ListMatches, opt },
          { "n", "ma", mt.cmd.MatchAdd, opt },
          { "v", "ma", mt.cmd.MatchAddVisual, opt },
        },
        setup_mappings_now = false,
        separators = { ["1"] = "", ["2"] = " " },
        lang_num = 2,
        enable_keybindings_hook = function()
          -- disable coc to avoid lag on :w
          if vim.g.did_coc_loaded ~= nil then vim.cmd [[CocDisable]] end
          -- disable the undo history saving, which is time-consuming and causes lag
          vim.opt_local.undofile = false
          pcall(vim.cmd.nunmap, "j")
          pcall(vim.cmd.nunmap, "k")
          pcall(vim.cmd.nunmap, "gj")
          pcall(vim.cmd.nunmap, "gk")
          vim.opt_local.undolevels = -1
          vim.opt_local.signcolumn = "no"
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          require "interlaced".cmd.Load()
          require "interlaced".ShowChunkNr()
        end,
      }
      require "interlaced".setup(opts)
    end
  },
  -- typst.vim
  {
    "kaarmu/typst.vim",
    ft = { "typst" },
    event = "VeryLazy",
    config = function()
      vim.g.typst_auto_open_quickfix = false
      vim.g.typst_syntax_highlight = false
    end,
  },
  -- fcitx.vim
  {
    "https://github.com/lilydjwg/fcitx.vim",
    enabled = true,
    event = "VeryLazy",
    config = function()
      vim.g.fcitx5_remote = "fcitx5-remote"
    end
  },
  -- im-select
  {
    "keaising/im-select.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require "im_select".setup {
        -- IM will be set to `default_im_select` in `normal` mode
        -- For Windows/WSL, default: "1033", aka: English US Keyboard
        -- For macOS, default: "com.apple.keylayout.ABC", aka: US
        -- For Linux, default:
        --               "keyboard-us" for Fcitx5
        --               "1" for Fcitx
        --               "xkb:us::eng" for ibus
        -- You can use `im-select` or `fcitx5-remote -n` to get the IM's name
        default_im_select = "keyboard-us",

        -- Restore the default input method state when the following events are triggered
        set_default_events = { "VimEnter", "InsertLeave", "CmdlineLeave" },

        -- Restore the previous used input method state when the following events
        -- are triggered, if you don't want to restore previous used im in Insert mode,
        -- e.g. deprecated `disable_auto_restore = 1`, just let it empty
        -- as `set_previous_events = {}`
        set_previous_events = { "InsertEnter", "CmdlineEnter" },

        -- Show notification about how to install executable binary when binary missed
        keep_quiet_on_no_binary = false,

        -- Async run `default_command` to switch IM or not
        async_switch_im = true
      }
    end,
  },
  -- markdown-preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    event = "VeryLazy",
    config = function() require "plugin_config.markdown_preview" end,
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
    "nvim-telescope/telescope.nvim",
    -- version = '*',
    enabled = true,
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require "plugin_config.telescope_nvim" end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    build = "make"
  },
  {
    "ibhagwan/fzf-lua",
    enabled = false,
    config = function() require "plugin_config.fzf_lua" end,
  },

  -- ChatGPT.nvim
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   enabled = false,
  --   event = "VeryLazy",
  --   config = function()
  --     require("plugin_config.chatgpt")
  --   end,
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim"
  --   },
  -- },
  {
    "https://github.com/robitx/gp.nvim",
    -- dir = "/home/tan/.local/share/nvim/lazy/gp.nvim",
    config = function()
      require "plugin_config.gp_nvim"
    end,
    event = "VeryLazy",
  },
  {
    -- use this to map jk to search placeholder
    "max397574/better-escape.nvim",
    version = "1.0.0",
    event = "VeryLazy",
    config = function()
      require "better_escape".setup {
        mapping = { "jk" },
        timeout = vim.o.timeoutlen,
        clear_empty_lines = false,
        -- insert mode mapping
        keys = '<Esc>/<<>><CR>:set nohlsearch<CR>"_c4<right>',
      }
      -- normal mode mapping
      keyset("n", "<SPACE><SPACE>", '/<<>><CR>:set nohlsearch<CR>"_c4<right>')
    end,
  },
  -- diffchar
  {
    "https://github.com/rickhowe/diffchar.vim",
    event = "VeryLazy",
  },
  {
    "neovim/nvim-lspconfig",
    enabled = false,
    event = { "BufRead", "BufNewFile" },
    config = function() require "plugin_config.lsp" end,
  },
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "quangnguyen30192/cmp-nvim-ultisnips",
    },
    config = function() require "plugin_config.nvim_cmp" end,
  },
  {
    "https://github.com/tpope/vim-fugitive",
    -- see ../plugin/autocmds.lua for InGitRepo
    event = "User InGitRepo",
    config = function() require "plugin_config.vim_fugitive" end
  },
  {
    "https://github.com/stevearc/oil.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require "oil".setup {
        columns = { "size", "mtime" },
        float = { border = "single", },
      }
      keyset("n", "zh", require "oil".toggle_hidden)
      keyset("n", "tt", require "oil".toggle_float)
    end
  },
  {
    "codota/tabnine-nvim",
    enabled = false,
    build = "./dl_binaries.sh",
    event = "VeryLazy",
    config = function()
      require "tabnine".setup {
        disable_auto_comment = true,
        accept_keymap = "<c-a>",
        dismiss_keymap = "<C-]>",
        debounce_ms = 500,
        suggestion_color = { gui = "#808080", cterm = 244 },
        exclude_filetypes = { "TelescopePrompt", "NvimTree" },
        log_file_path = nil, -- absolute path to Tabnine log file
        ignore_certificate_errors = false,
      }
    end
  },
  {
    "monkoose/neocodeium",
    enabled = false,
    event = "VeryLazy",
    config = function()
      local neocodeium = require "neocodeium"
      neocodeium.setup()
      vim.keymap.set("i", "<Tab>", neocodeium.accept_line)
    end,
  },
  {
    "luozhiya/fittencode.nvim",
    event = "VeryLazy",
    config = function()
      require "fittencode".setup {
        action = {
          identify_programming_language = {
            -- Identify programming language of the current buffer
            -- * Unnamed buffer
            -- * Buffer without file extension
            -- * Buffer no filetype detected
            identify_buffer = false,
          },
        },
        keymaps = {
          inline = {
            ["<c-Tab>"] = "accept_all_suggestions",
            ["<c-Right>"] = "accept_word",
            ["<s-Right>"] = "accept_char",
            ["<right>"] = "accept_line",
            ["<c-a>"] = "triggering_completion",
          },
        }, }
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

require "lazy".setup(plugin_specs, lazy_opts)
