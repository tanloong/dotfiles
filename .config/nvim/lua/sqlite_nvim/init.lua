#!/usr/bin/env lua

vim.api.nvim_create_user_command("SQLite", function() local client = require("sqlite_nvim.sqlite") ; client.main() end, {})
