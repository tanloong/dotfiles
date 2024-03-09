local keyset = vim.keymap.set
local telescope = require("telescope")
local builtin = require('telescope.builtin')
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

keyset('n', '<leader>b', builtin.buffers, {})
keyset('n', '<leader><leader>', builtin.find_files, {})
keyset('n', '<leader>g', builtin.live_grep, {})
keyset('n', '<leader>*', builtin.grep_string, {})
keyset('n', '<leader>h', builtin.help_tags, {})
keyset('n', '<c-/>',
    function()
        builtin.current_buffer_fuzzy_find({ skip_empty_lines = true })
    end, {})
keyset('n', '<leader>/',
    function()
        builtin.find_files({ cwd = vim.fn.stdpath('config'), follow = true })
    end, {})

vim.cmd([[
    " https://stackoverflow.com/questions/11858927/preventing-trailing-whitespace-when-using-vim-abbreviations
    func! Eatchar(pat)
      let c = nr2char(getchar(0))
      return (c =~ a:pat) ? '' : c
    endfunc
    cabbrev <expr> h (getcmdtype() == ':' && getcmdline() == 'h' ?
                     \ 'Telescope help_tags<cr><c-r>=Eatchar(" ")<cr>'
                     \: 'h')
    cabbrev <expr> Man (getcmdtype() == ':' && getcmdline() == 'Man' ?
                       \ 'Telescope man_pages<cr><c-r>=Eatchar(" ")<cr>'
                       \: 'h')
    ]])
