#!/usr/bin/env lua

local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp

local function executable(name)
  return fn.executable(name) > 0
end

local custom_attach = function(client, bufnr)
  local map = function(mode, l, r, opts)
    opts = opts or {}
    opts.silent = true
    opts.buffer = bufnr
    keymap.set(mode, l, r, opts)
  end

  map("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
  map("n", "<C-]>", vim.lsp.buf.definition)
  map("n", "<leader>s", vim.lsp.buf.hover)
  map("n", "<leader>s", vim.lsp.buf.signature_help)
  map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "varialbe rename" })
  map("n", "gr", vim.lsp.buf.references, { desc = "show references" })
  map("n", "[d", vim.diagnostic.goto_prev, { desc = "previous diagnostic" })
  map("n", "]d", vim.diagnostic.goto_next, { desc = "next diagnostic" })
  map("n", "<leader>q", function()
    vim.diagnostic.setqflist { open = true }
  end, { desc = "put diagnostic to qf" })
  map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })
  map("n", "<leader>wl", function()
    vim.inspect(vim.lsp.buf.list_workspace_folders())
  end, { desc = "list workspace folder" })

  -- Set some key bindings conditional on server capabilities
  if client.server_capabilities.document_formatting then
    map("n", "<leader>f", vim.lsp.buf.formatting_sync, { desc = "format code" })
  end
  if client.server_capabilities.document_range_formatting then
    map("x", "<leader>f", vim.lsp.buf.range_formatting, { desc = "range format" })
  end

  api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local float_opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "single",
        source = "always", -- show source in diagnostic popup window
        prefix = " ",
      }

      if not vim.b.diagnostics_pos then
        vim.b.diagnostics_pos = { nil, nil }
      end

      local cursor_pos = api.nvim_win_get_cursor(0)
      if
        (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2])
        and #vim.diagnostic.get() > 0
      then
        vim.diagnostic.open_float(nil, float_opts)
      end

      vim.b.diagnostics_pos = cursor_pos
    end,
  })

  -- The below command will highlight the current variable and its usages in the buffer.
  if client.server_capabilities.document_highlight then
    for _, cgroup in ipairs{
      'LspReferenceRead',
      'LspReferenceText',
      'LspReferenceWrite',
  } do
      api.nvim_set_hl(0, cgroup, { ctermbg = 237, bg = '#3A3A3A' })
    end
    api.nvim_create_autocmd("CursorHold",
        {
            pattern = "*",
            buffer = 0,
            group = api.nvim_create_augroup("lsp_document_highlight", { clear = true }),
            callback = vim.lsp.buf.document_highlight,
        })
    api.nvim_create_autocmd("CursorMoved",
        {
            pattern = "*",
            buffer = 0,
            group = api.nvim_create_augroup("lsp_document_highlight", { clear = true }),
            callback = vim.lsp.buf.clear_references,
        })
      end

  if vim.g.logging_level == "debug" then
    local msg = string.format("Language server %s started!", client.name)
    vim.notify(msg, vim.log.levels.DEBUG, { title = "Nvim-config" })
  end
end

-- local capabilities = lsp.protocol.make_client_capabilities()
-- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
local capabilities = require('blink.cmp').get_lsp_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require("lspconfig")

if executable("pyright") then
  lspconfig.pyright.setup {
    on_attach = custom_attach,
    capabilities = capabilities,
  }
else
  vim.notify("pyright not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

-- set up bash-language-server
if executable("bash-language-server") then
  lspconfig.bashls.setup {
    on_attach = custom_attach,
    capabilities = capabilities,
  }
end

-- settings for lua-language-server can be found on https://luals.github.io/wiki/settings/
if executable("lua-language-server") then
  lspconfig.lua_ls.setup {
    on_attach = custom_attach,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        hint = {
          enable = true
        }
      },
    },
    capabilities = capabilities,
  }
end

-- Change diagnostic signs.
-- fn.sign_define("DiagnosticSignError", { text = "●", texthl = "DiagnosticSignError" })
-- fn.sign_define("DiagnosticSignWarn", { text = "●", texthl = "DiagnosticSignWarn" })
-- fn.sign_define("DiagnosticSignInformation", { text = "●", texthl = "DiagnosticSignInfo" })
-- fn.sign_define("DiagnosticSignHint", { text = "●", texthl = "DiagnosticSignHint" })

local i = '●'
-- global config for diagnostic
vim.diagnostic.config {
  underline = false,
  virtual_text = false,
  signs = {
    text = { i, i, i, i },
  },
  severity_sort = true,
}

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, { border = "single", })
