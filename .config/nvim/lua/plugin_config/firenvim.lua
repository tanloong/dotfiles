local map = vim.keymap.set
local api = vim.api

vim.g.firenvim_config = {
  globalSettings = { alt = "all" },
  localSettings = {
    [".*"] = {
      cmdline = "neovim",
      content = "text",
      priority = 0,
      selector = "textarea",
      -- don't auto enter neovim on textarea
      takeover = "never"
    }
  }
}
api.nvim_create_autocmd({ "UIEnter" }, {
  callback = function(e)
    local client = api.nvim_get_chan_info(vim.v.event.chan).client
    if client == nil or client.name ~= "Firenvim" then return end

    -- minimal lines and columns
    local min_lines = 7
    local max_lines = 20
    local min_columns = 80
    local max_columns = 130

    -- font
    local default_fontsize = 22
    local min_fontsize = 14
    local max_fontsize = 32
    local font_template = "Cousine Nerd Font Mono:h%d,WenQuanYi Zen Hei:h%d"
    --
    -- vim.opt.guifont = string.format(font_template, default_fontsize, default_fontsize)
    vim.opt.guifont = string.format("Cousine Nerd Font Mono,WenQuanYi Zen Hei", default_fontsize, default_fontsize)
    vim.opt.laststatus = 0

    -- increase font size
    map({ "n", "i" }, "<c-s-k>", function()
      if not vim.g.started_by_firenvim then return end
      local font = vim.opt_local.guifont._value
      local size = tonumber(font:match ":[hw](%d+)")
      if size >= max_fontsize then return end
      vim.opt_local.guifont = font:gsub(size, size + 2)
      vim.opt_local.lines = math.min(math.max(vim.opt_local.lines._value, min_lines), max_lines)
      vim.opt_local.columns = math.min(math.max(vim.opt_local.columns._value, min_columns), max_columns)
    end)
    -- decrease font size
    map({ "n", "i" }, "<c-s-j>", function()
      if not vim.g.started_by_firenvim then return end
      local font = vim.opt_local.guifont._value
      local size = tonumber(font:match ":[hw](%d+)")
      if size <= min_fontsize then return end
      vim.opt_local.guifont = font:gsub(size, size - 2)
      vim.opt_local.lines = math.min(math.max(vim.opt_local.lines._value, min_lines), max_lines)
      vim.opt_local.columns = math.min(math.max(vim.opt_local.columns._value, min_columns), max_columns)
    end)
    -- default font size
    map({ "n", "i" }, "<c-s-space>", function()
      if not vim.g.started_by_firenvim then return end
      local font = vim.opt_local.guifont._value
      local size = tonumber(font:match ":[hw](%d+)")
      if size == default_fontsize then return end
      vim.opt_local.guifont = string.format(font_template, default_fontsize, default_fontsize)
      vim.opt_local.lines = math.min(math.max(vim.opt_local.lines._value, min_lines), max_lines)
      vim.opt_local.columns = math.min(math.max(vim.opt_local.columns._value, min_columns), max_columns)
    end)
    -- Expand textarea as more lines are typed
    -- ref. https://github.com/glacambre/firenvim/issues/1619
    api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
      group = api.nvim_create_augroup("ExpandLinesOnTextChanged", { clear = true }),
      callback = function(e)
        local height = api.nvim_win_text_height(0, {}).all
        if height > vim.o.lines and height < max_lines then vim.o.lines = height end
      end
    })
  end
})
