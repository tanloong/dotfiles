local keyset = vim.keymap.set
local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
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
})

keyset("n", "<leader>b", builtin.buffers, {})
keyset("n", "<leader><leader>", builtin.find_files, {})
keyset("n", "<leader>G", builtin.live_grep, {})
keyset("n", "<leader>*", builtin.grep_string, {})
keyset("n", "<leader>h", builtin.help_tags, {})
keyset("n", "<c-/>",
  function()
    builtin.current_buffer_fuzzy_find({ skip_empty_lines = true })
  end, {})
keyset("n", "<leader>v",
  function()
    local dotdir = "~/projects/dotfiles/"
    local chunk, _ = loadfile(vim.fs.joinpath(dotdir, ".nvim.lua"))
    if chunk ~= nil then
      chunk()
    end
    builtin.find_files({
      cwd = dotdir,
      follow = true,
      hidden = true
    })
  end, {})
keyset("n", "<leader>m",
  function()
    builtin.find_files({ cwd = "~/docx/memorandum/", follow = true })
  end, {})

vim.cmd([[
    cabbrev <expr> h (getcmdtype() == ':' && getcmdline() == 'h' ?
                     \ 'Telescope help_tags<cr><c-r>=DT#Eatchar(" ")<cr>'
                     \: 'h')
    cabbrev <expr> Man (getcmdtype() == ':' && getcmdline() == 'Man' ?
                       \ 'Telescope man_pages<cr><c-r>=DT#Eatchar(" ")<cr>'
                       \: 'h')
    ]])
