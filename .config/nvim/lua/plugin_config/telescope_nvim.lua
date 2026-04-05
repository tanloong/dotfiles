local keyset = vim.keymap.set
local telescope = require "telescope"
local builtin = require "telescope.builtin"
local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    prompt_prefix = " ",
    selection_caret = "▌ ",
    entry_prefix = "  ",
    border = true,
    preview = false,
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = { prompt_position = "top" },
      width = { padding = 0 },
      height = { padding = 0 },
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<c-u>"] = false,
        ["<c-j>"] = actions.move_selection_next,
        ["<c-k>"] = actions.move_selection_previous,
      },
    },
    results_title = false,
    borderchars = {
      prompt = { " ", " ", " ", " ", " ", " ", " ", " " },
      results = { " ", " ", " ", " ", " ", " ", " ", " " },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
  },
}
require "telescope".load_extension "fzf"

keyset("n", "<space>fb", builtin.buffers, {})
keyset("n", "<space>fd", builtin.find_files, {})
keyset("n", "<space>fl", builtin.live_grep, {})
keyset("n", "<space>fw", builtin.grep_string, {})
keyset("n", "<space>fh", builtin.help_tags, {})
keyset("n", "<space>/",
  function()
    builtin.current_buffer_fuzzy_find { skip_empty_lines = true }
  end, {})
keyset("n", "<space>fc",
  function()
    local cwd = "~/docx/corpus/BNC/02BNC_txt"
    builtin.live_grep {
      cwd = cwd,
      follow = true,
      hidden = true,
      disable_coordinates = true,
    }
  end, {})
keyset("n", "<space>fo",
  function()
    local dotdir = vim.fn.hostname() == "PC-20250602IQJE" and "D:/docx/Obsidian Vault" or "C:/Users/Administrator/Desktop/Obsidian Vault"
    builtin.find_files {
      cwd = dotdir,
      follow = true,
      hidden = true
    }
  end, {})
keyset("n", "<space>fv",
  function()
    local dotdir = vim.fn.has "win32" == 1 and (vim.fn.hostname() == "XB-20220816OSUK" and [[C:\Users\Administrator\Desktop\dotfiles]] or "D:/projects/dotfiles") or vim.fs.joinpath("~", "projects/dotfiles/")
    local chunk, _ = loadfile(vim.fs.joinpath(dotdir, ".nvim.lua"))
    if chunk ~= nil then
      chunk()
    end
    builtin.find_files {
      cwd = dotdir,
      follow = true,
      hidden = true
    }
  end, {})
keyset("n", "<space>fm",
  function()
    builtin.find_files {
      cwd = vim.fs.joinpath(
        vim.fn.has "win32" == 1 and "D:" or "~",
        "docx/memorandum/"), follow = true }
  end, {})

vim.cmd [[
    cabbrev <expr> h (getcmdtype() == ':' && getcmdline() == 'h' ?
                     \ 'Telescope help_tags<cr><c-r>=DT#Eatchar(" ")<cr>'
                     \: 'h')
    cabbrev <expr> Man (getcmdtype() == ':' && getcmdline() == 'Man' ?
                       \ 'Telescope man_pages<cr><c-r>=DT#Eatchar(" ")<cr>'
                       \: 'h')
    ]]

local hl = vim.api.nvim_set_hl
hl(0, "TelescopeSelection", { fg = "#eeeeee", bg = "#303030" })
hl(0, "TelescopeSelectionCaret", { fg = "#d7005f", bg = "#303030" })
hl(0, "TelescopeMatching", { fg = "#ffc978" })
