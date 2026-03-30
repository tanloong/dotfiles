#!/usr/bin/env lua

local M = {}

M.action = {
  main = function(a)
    local sqlite = require("sqlite_nvim.sqlite")
    sqlite.main()
  end,

  switch = function(a)
    local sqlite = require("sqlite_nvim.sqlite")
    sqlite.show_database_selector()
  end,

  edit = function(a)
    local sqlite = require("sqlite_nvim.sqlite")
    sqlite.edit_database_list()
  end,

  setup = function(a)
    local sqlite = require("sqlite_nvim.sqlite")
    local config = {}
    if a.args and a.args ~= "" then
      local ok, parsed = pcall(vim.json.decode, a.args)
      if ok then
        config = parsed
      else
        vim.notify("Invalid JSON configuration", vim.log.levels.ERROR)
        return
      end
    end
    sqlite.setup(config)
  end
}

M.setup = function()
  vim.api.nvim_create_user_command("SQLite", function(a)
    local action

    -- 如果没有参数，默认执行 main
    if not a.fargs or #a.fargs == 0 then
      action = M.action.main
    else
      for _, provider in ipairs({ M }) do
        action = provider.action[a.fargs[1]]
        if action ~= nil then break end
      end
    end

    if action ~= nil then
      if a.fargs and #a.fargs > 0 then
        a.args = vim.trim(a.args:sub(#a.fargs[1] + 1))
        table.remove(a.fargs, 1)
      end
      return action(a)
    else
      vim.notify(string.format("SQLite subcommand '%s' not found", a.fargs[1] or ""), vim.log.levels.ERROR)
    end
  end, {
    complete = function(_, line)
      local candidates = vim.iter({ M.action }):map(vim.tbl_keys):flatten():totable()
      table.sort(candidates)
      local args = vim.split(vim.trim(line), "%s+")
      if vim.tbl_count(args) > 2 then return end
      table.remove(args, 1)
      local prefix = table.remove(args, 1)
      if prefix and line:sub(-1) == " " then return end
      if not prefix then
        return candidates
      else
        return vim.fn.matchfuzzy(candidates, prefix)
      end
    end,
    nargs = "*"
  })
end

return M
