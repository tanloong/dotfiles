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
