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
  -- CoC
  {
    -- "https://github.com/neoclide/coc.nvim.git",
    "https://gitee.com/linuor/coc.nvim",
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
  -- vim-markdown-toc
  {
    "https://github.com/mzlogin/vim-markdown-toc",
    ft = { "markdown" },
    event = "VeryLazy",
    config = function() require "plugin_config.vim_markdown_toc" end
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
    enabled = false,
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
      vim.g.interlaced = {
        keymaps = {
          { "n", ",", rpst.cmd.push_up, opt },
          { "n", "<", rpst.cmd.push_up_pair, opt },
          { "n", "e", rpst.cmd.push_up_left_part, opt },
          { "n", ".", rpst.cmd.pull_below, opt },
          { "n", ">", rpst.cmd.pull_below_pair, opt },
          { "n", "d", rpst.cmd.push_down_right_part, opt },
          { "n", "D", rpst.cmd.push_down, opt },
          { "n", "s", rpst.cmd.leave_alone, opt },
          { "n", "[e", rpst.cmd.swap_with_above, opt },
          { "n", "]e", rpst.cmd.swap_with_below, opt },
          { "n", "U", rpst.cmd.undo, opt },
          { "n", "R", rpst.cmd.redo, opt },
          { "n", "J", rpst.cmd.navigate_down, opt },
          { "n", "K", rpst.cmd.navigate_up, opt },
          { "n", "md", it.cmd.dump, opt },
          { "n", "ml", it.cmd.load, opt },
          { "n", "gn", rpst.cmd.next_unaligned, opt },
          { "n", "gN", rpst.cmd.prev_unaligned, opt },
          { "n", "mt", mt.cmd.match_toggle, opt },
          { "n", "m;", mt.cmd.list_matches, opt },
          { "n", "ma", mt.cmd.match_add, opt },
          { "v", "ma", mt.cmd.match_add_visual, opt },
        },
        setup_mappings_now = false,
        separators = { ["1"] = "", ["2"] = " " },
        lang_num = 2,
        enable_keybindings_hook = function()
          -- disable coc to avoid lag on :w
          if vim.g.did_coc_loaded ~= nil then vim.cmd [[CocDisable]] end
          -- disable the undo history saving, which is time-consuming and causes lag
          vim.opt_local.undofile = false
          -- pcall(vim.cmd.nunmap, "j")
          -- pcall(vim.cmd.nunmap, "k")
          -- pcall(vim.cmd.nunmap, "gj")
          -- pcall(vim.cmd.nunmap, "gk")
          -- vim.opt_local.undolevels = -1
          vim.opt_local.signcolumn = "no"
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          require "interlaced".cmd.load()
          require "interlaced".ShowChunkNr()
        end,
        sound_feedback = true,
      }
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
  -- markdown-preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    event = "VeryLazy",
    config = function() require "plugin_config.markdown_preview" end,
  },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
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
    "https://github.com/robitx/gp.nvim",
    -- dir = "/home/usr/.local/share/nvim/lazy/gp.nvim",
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
    "https://github.com/folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "saghen/blink.cmp",
    enabled = true,
    -- optional: provides snippets for the snippet source
    dependencies = { "rafamadriz/friendly-snippets", "luozhiya/fittencode.nvim",
      "Kaiser-Yang/blink-cmp-dictionary", },

    -- use a release tag to download pre-built binaries
    version = "*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = "default" },
      completion = {
        list = {
          selection = {
            -- don't auto select the first item, do preview on selection
            preselect = true,
            auto_insert = true
          }
        },
        menu = {
          draw = {
            -- columns = { { "label" }, { "kind" } },
            columns = { { "label" } },
          }
        }
      },
      sources = {
        default = { "lazydev", "lsp", "snippets", "buffer", "path", "dictionary" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
          dictionary = {
            module = "blink-cmp-dictionary",
            name = "Dict",
            -- Make sure this is at least 2.
            -- 3 is recommended
            min_keyword_length = 3,
            max_items = 4,
            opts = {
              dictionary_files = { vim.api.nvim_get_option_value("dictionary", {}) },
            },
            score_offset = -50,
          },
        },
      },
    },
    opts_extend = { "sources.default" }
  },
  {
    "https://github.com/tpope/vim-fugitive",
    -- see ../plugin/autocmds.lua for InGitRepo
    event = "User InGitRepo",
    config = function() require "plugin_config.vim_fugitive" end
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
        inline_completion = {
          enable = true,
          auto_triggering_completion = false,
          disable_completion_within_the_line = false,
        },
        keymaps = {
          inline = {
            ["<Tab>"] = "accept_all_suggestions",
            ["<c-Right>"] = "accept_word",
            ["<s-Right>"] = "accept_line",
          },
        }, }
      keyset({ "i", "n" }, "<s-tab>", function()
        require "fittencode".dismiss_suggestions()
        require "fittencode".enable_completions { enable = false }
      end)
      keyset({ "i", "n" }, "<c-tab>", function()
        require "fittencode".enable_completions { enable = true }
        require "fittencode".triggering_completion()
      end)
    end,
  },
  {
    "glacambre/firenvim",
    enabled = true,
    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    lazy = not vim.g.started_by_firenvim,
    module = false,
    build = ":call firenvim#install(0)",
    config = function()
      vim.g.firenvim_config = {
        globalSettings = { alt = "all" },
        localSettings = {
          [".*"] = {
            cmdline = "neovim",
            content = "text",
            priority = 0,
            selector = "textarea",
            -- don't auto enter neovim on textarea
            takeover = "never"
          }
        }
      }
      vim.api.nvim_create_autocmd({ "UIEnter" }, {
        callback = function(e)
          local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
          if client == nil or client.name ~= "Firenvim" then return end

          -- minimal lines and columns
          local min_lines = 7
          local max_lines = 20
          local min_columns = 80
          local max_columns = 130

          -- font
          local default_fontsize = 22
          local min_fontsize = 14
          local max_fontsize = 32
          -- local font_template = "Cousine Nerd Font Mono:h%d,WenQuanYi Zen Hei:h%d"
          --
          -- vim.opt.guifont = string.format(font_template, default_fontsize, default_fontsize)
          vim.opt.guifont = string.format("Cousine Nerd Font Mono,WenQuanYi Zen Hei", default_fontsize, default_fontsize)
          vim.opt.laststatus = 0

          -- increase font size
          keyset({ "n", "i" }, "<c-s-k>", function()
            if not vim.g.started_by_firenvim then return end
            local font = vim.opt_local.guifont._value
            local size = tonumber(font:match ":[hw](%d+)")
            if size >= max_fontsize then return end
            vim.opt_local.guifont = font:gsub(size, size + 2)
            vim.opt_local.lines = math.min(math.max(vim.opt_local.lines._value, min_lines), max_lines)
            vim.opt_local.columns = math.min(math.max(vim.opt_local.columns._value, min_columns), max_columns)
          end)
          -- decrease font size
          keyset({ "n", "i" }, "<c-s-j>", function()
            if not vim.g.started_by_firenvim then return end
            local font = vim.opt_local.guifont._value
            local size = tonumber(font:match ":[hw](%d+)")
            if size <= min_fontsize then return end
            vim.opt_local.guifont = font:gsub(size, size - 2)
            vim.opt_local.lines = math.min(math.max(vim.opt_local.lines._value, min_lines), max_lines)
            vim.opt_local.columns = math.min(math.max(vim.opt_local.columns._value, min_columns), max_columns)
          end)
          -- default font size
          keyset({ "n", "i" }, "<c-s-space>", function()
            if not vim.g.started_by_firenvim then return end
            local font = vim.opt_local.guifont._value
            local size = tonumber(font:match ":[hw](%d+)")
            if size == default_fontsize then return end
            vim.opt_local.guifont = string.format(font_template, default_fontsize, default_fontsize)
            vim.opt_local.lines = math.min(math.max(vim.opt_local.lines._value, min_lines), max_lines)
            vim.opt_local.columns = math.min(math.max(vim.opt_local.columns._value, min_columns), max_columns)
          end)
          -- Expand textarea as more lines are typed
          -- ref. https://github.com/glacambre/firenvim/issues/1619
          vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
            group = vim.api.nvim_create_augroup("ExpandLinesOnTextChanged", { clear = true }),
            callback = function(e)
              local height = vim.api.nvim_win_text_height(0, {}).all
              if height > vim.o.lines and height < max_lines then vim.o.lines = height end
            end
          })
        end
      })
    end
  },
  {
    dir = "/home/usr/projects/bite.nvim/",
    -- event = "VeryLazy",
    cmd = "B",
    build = "<cmd>UpdateRemotePlugins<cr>",
    config = function()
      require "bite"
    end,
  },
  {
    dir = "/home/usr/projects/term.nvim/",
    cmd = "Term",
    config = function()
      require "term"
    end,
  },
  ----------------------------------- DISABLED -----------------------------------{{{
  {
    "folke/snacks.nvim",
    enabled = false,
    priority = 1000,
    lazy = false,
    opts = {
      image = { enabled = true },
    },
  },
  { "https://github.com/meznaric/key-analyzer.nvim", enabled = false, cmd = "KeyAnalyzer", opts = {} },
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
  -- vim-table-mode
  {
    "https://gitee.com/yaozhijin/vim-table-mode.git",
    enabled = false,
    ft = { "markdown" },
    event = "VeryLazy",
    config = function() require "plugin_config.vim_table_mode" end
  },
  -- hlsearch
  {
    -- 'nvimdev/hlsearch.nvim',
    dir = "/home/usr/projects/hlsearch.nvim/",
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
  {
    "ibhagwan/fzf-lua",
    enabled = false,
    config = function() require "plugin_config.fzf_lua" end,
  },
  -- ChatGPT.nvim
  {
    "jackMort/ChatGPT.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require "plugin_config.chatgpt"
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    },
  },
  {
    "https://github.com/stevearc/oil.nvim",
    enabled = true,
    lazy = false,
    config = function()
      require "plugin_config.oil" 
    end
  },
  {
    "subnut/nvim-ghost.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      -- vim.g.nvim_ghost_autostart = 0
      -- vim.g.nvim_ghost_super_quiet = 1 -- suppress all messages
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
  }, -- }}}
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
