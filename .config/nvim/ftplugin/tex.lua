vim.opt.conceallevel=0
vim.keymap.set('n', '<LEADER><F5>', '<Plug>(vimtex-compile)')
-- call matchadd('Conceal','\$',9999,-1,{'conceal':'$'})
-- don't hide dollar sign 
-- if priority 9999 is not given, the above line does not work