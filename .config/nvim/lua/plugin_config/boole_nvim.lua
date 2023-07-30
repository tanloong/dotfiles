#!/usr/bin/env lua

require('boole').setup({
  mappings = {
    increment = '<C-a>',
    decrement = '<C-x>'
  },
  -- User defined loops
  additions = {
    {'True', 'False'},
    {'true', 'false'},
    {'TRUE', 'FALSE'},
    {'T', 'F'},
  },
  allow_caps_additions = {
    {'enable', 'disable'}
    -- enable → disable
    -- Enable → Disable
    -- ENABLE → DISABLE
  }
})
