#!/usr/bin/env lua

---Default configuration values for Phoenix
---@type PhoenixConfig
vim.g.phoenix = {
  -- Enable for all filetypes by default
  filetypes = { '*' },

  -- Dictionary settings control word storage
  dict = {
    capacity = 50000, -- Store up to 50k words
    min_word_length = 2, -- Ignore single-letter words
    word_pattern = '[^%s%.%_:%p%d]+', -- Word pattern
  },

  -- Completion control the scoring
  completion = {
    max_items = 1000, -- Max result items
    decay_minutes = 30, -- Time period for decay calculation
    weights = {
      recency = 0.3, -- 30% weight to recent usage
      frequency = 0.7, -- 70% weight to frequency
    },
    priority = {
      base = 100, -- Base priority score (0-999)
      position = 'after', -- Position relative to other LSP results: 'before' or 'after'
    },
  },

  -- Cleanup settings control dictionary maintenance
  cleanup = {
    cleanup_batch_size = 1000, -- Process 1000 words per batch
    frequency_threshold = 0.1, -- Keep words used >10% of max frequency
    collection_batch_size = 100, -- Collect 100 words before yielding
    rebuild_batch_size = 100, -- Rebuild 100 words before yielding
    idle_timeout_ms = 1000, -- Wait 1s before cleanup
    cleanup_ratio = 0.9, -- Cleanup at 90% capacity
    enable_notify = false, -- Enable notify when cleanup dictionary
  },

  -- Scanner settings control filesystem interaction
  scanner = {
    scan_batch_size = 1000, -- Scan 1000 items per batch
    cache_duration_ms = 5000, -- Cache results for 5s
    throttle_delay_ms = 150, -- Wait 150ms between updates
    ignore_patterns = {}, -- Dictionary or file ignored when path completion
  },
}

-- -- requires 0.11
-- local api, completion, lsp = vim.api, vim.lsp.completion, vim.lsp
-- local ms = lsp.protocol.Methods
-- local InsertCharPre = 'InsertCharPre'
-- local pumvisible = vim.fn.pumvisible
-- local g = api.nvim_create_augroup('phoenix', { clear = true })
--
-- vim.opt.cot = 'menu,menuone,noinsert,popup,fuzzy'
-- vim.opt.cia = 'kind,abbr,menu'
--
-- api.nvim_create_autocmd('LspAttach', {
--   group = g,
--   callback = function(args)
--     local bufnr = args.buf
--     local client = lsp.get_client_by_id(args.data.client_id)
--     if not client or not client:supports_method(ms.textDocument_completion) then
--       return
--     end
--
--     completion.enable(true, client.id, bufnr, {
--       autotrigger = true,
--       convert = function(item)
--         local kind = lsp.protocol.CompletionItemKind[item.kind] or 'u'
--         return {
--           abbr = item.label:gsub('%b()', ''),
--           kind = kind:sub(1, 1):lower(),
--           kind_hlgroup = ('@lsp.type.%s'):format(kind:sub(1, 1):lower() .. kind:sub(2)),
--         }
--       end,
--     })
--     if #api.nvim_get_autocmds({ buffer = bufnr, event = 'InsertCharPre', group = g }) ~= 0 then
--       return
--     end
--     api.nvim_create_autocmd(InsertCharPre, {
--       buffer = bufnr,
--       group = g,
--       callback = function()
--         if tonumber(pumvisible()) == 1 then
--           return
--         end
--         local triggerchars = vim.tbl_get(
--           client,
--           'server_capabilities',
--           'completionProvider',
--           'triggerCharacters'
--         ) or {}
--         if vim.v.char:match('[%w_]') and not vim.list_contains(triggerchars, vim.v.char) then
--           vim.schedule(function()
--             completion.trigger()
--           end)
--         end
--       end,
--       desc = 'glepnir: completion on character which not exist in lsp client triggerCharacters',
--     })
--   end,
-- })
