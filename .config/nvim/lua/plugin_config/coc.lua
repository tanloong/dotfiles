#!/usr/bin/env lua
local keymap = vim.keymap.set
local api = vim.api
local hi = api.nvim_set_hl

hi(0, 'CocMenuSel', { link = 'PmenuSel' })
hi(0, 'CocPumSearch', { ctermfg = 'yellow' })
hi(0, 'CocInlayHint', { ctermbg = 'none', ctermfg = 'darkgray' })
hi(0, 'CocHintVirtualText', { ctermbg = 'none', ctermfg = 'darkgray' })
hi(0, 'CocErrorFloat', {ctermbg='none', ctermfg='red'})

keymap('n', '<leader>c', ':CocCommand<space>')
-- Use tab for trigger completion with characters ahead and navigate.
-- NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
-- other plugin before putting this into your config.
vim.cmd([[
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
]])
-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice.
vim.cmd([[
inoremap <silent><expr> <CR> coc#pum#visible() ?
                              \ coc#pum#info()['index'] >= 0 ?
                              \ coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
]])
vim.cmd([[
    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
  ]])
-- function _G.check_back_space()
-- local col = vim.fn.col('.') - 1
-- return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
-- end
-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
keymap("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
keymap("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })
-- GoTo code navigation.
keymap("n", "gd", "<Plug>(coc-definition)", { silent = true })
keymap("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keymap("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keymap("n", "gr", "<Plug>(coc-references)", { silent = true })
-- Show documentation in preview window.
keymap("n", "<leader>s", '<CMD>lua _G.show_docs()<CR>', { silent = true })
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
        api.nvim_command('h ' .. cw)
    elseif api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end

-- Highlight the symbol and its references when holding the cursor.
-- api.nvim_create_augroup("CocGroup", {})
-- api.nvim_create_autocmd("CursorHold", {
--     group = "CocGroup",
--     command = "silent call CocActionAsync('highlight')",
--     desc = "Highlight symbol under cursor on CursorHold"
-- })
-- api.nvim_set_hl(0, 'CocHighlightText', { ctermbg = 'DarkGray' })

-- Symbol renaming.
keymap("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })
-- Formatting selected code.
keymap("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
keymap("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
-- Applying codeAction to the selected region.
-- Example: `<leader>aap` for current paragraph
local opts = { silent = true, nowait = true }
-- keymap("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
-- keymap("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
-- Apply AutoFix to problem on the current line.
keymap("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)
-- Remap <C-f> and <C-b> for scroll float windows/popups.
-- @diagnostic disable-next-line: redefined-local
opts = { silent = true, nowait = true, expr = true }
keymap("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keymap("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
keymap("i", "<C-f>",
    'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
keymap("i", "<C-b>",
    'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
keymap("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keymap("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
-- Use CTRL-S for selections ranges.
-- Requires 'textDocument/selectionRange' support of language server.
keymap("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
keymap("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
-- vim.cmd([[set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P]])
vim.cmd([[set statusline=%<%f\ %h%m%{coc#status()}%{get(b:,'coc_current_function','')}%r%=%-14.(%l,%c%V%)\ %p%%]])
-- Add `:Format` command to format current buffer.
api.nvim_create_user_command("Format", "call CocAction('format')", {})
keymap('n', '<leader>f', ":call CocActionAsync('format')<CR>")
-- " Add `:Fold` command to fold current buffer.
api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = '?' })
-- Add `:OR` command for organize imports of the current buffer.
api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

-- coc-extensions{{{
vim.g['coc_global_extensions'] = {
    'coc-git',
    'coc-snippets',
    'coc-sumneko-lua',
    'coc-json',
    'coc-dictionary',
    'coc-pyright',
    'coc-webview',
    'coc-markdown-preview-enhanced',
}
-- 'coc-html',
-- 'coc-tsserver',
-- 'coc-actions',
-- 'coc-explorer',
-- 'coc-java',
-- 'coc-r-lsp',
-- \ 'coc-smartf',
-- \ 'coc-vimtex',
-- \ 'coc-sh',
-- \ 'coc-texlab',
-- \ 'coc-clangd',

-- coc-explorer
-- keymap("n", "tt", "<Cmd>CocCommand explorer<CR>")

-- }}}
-- coc-snippets{{{
-- Use <C-o> for trigger snippet expand.
keymap('i', '<c-o>', '<Plug>(coc-snippets-expand)')
-- Use <C-j> for jump to next placeholder, it's default of coc.nvim
vim.g['coc_snippet_next'] = '<c-j>'
-- Use <C-k> for jump to previous placeholder, it's default of coc.nvim
vim.g['coc_snippet_prev'] = '<c-k>'
-- }}}
-- coc-outline{{{
api.nvim_set_keymap('n', 'so', ':lua ToggleOutline()<CR>', {silent = true, nowait = true})

function ToggleOutline()
  local winid = vim.fn['coc#window#find']('cocViewId', 'OUTLINE')
  if winid == -1 then
    vim.fn['CocActionAsync']('showOutline', 1)
  else
    vim.fn['coc#window#close'](winid)
  end
end-- }}}
