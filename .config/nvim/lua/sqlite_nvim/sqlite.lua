local M = {}
local api = vim.api
local bin_path = [[sqlite3]]

M.config = {
  databases = {
    [[D:\usr\boyi\tasks\20251114-委托成交入库\xt.db]],
    [[D:\usr\boyi\tasks\20251208-每日净值推送\net.db]],
    [[D:\usr\boyi\tasks\20250728-profit-curve\src\curve\profit.db]],
  },
  current_db_index = 1,
  keymap = "<c-g><c-g>",
  timeout = 30000,
}

local function is_blank_line(line)
  return line:gsub("%s+", "") == ""
end

local function get_cursor_paragraph()
  local cursor_pos = api.nvim_win_get_cursor(0)
  local cursor_row_0based = cursor_pos[1] - 1

  local start_row = cursor_row_0based
  while start_row > 0 do
    local line = api.nvim_buf_get_lines(0, start_row - 1, start_row, false)[1]
    if is_blank_line(line) then
      break
    end
    start_row = start_row - 1
  end

  local line_count = api.nvim_buf_line_count(0)
  local end_row = cursor_row_0based
  while end_row < line_count - 1 do
    local line = api.nvim_buf_get_lines(0, end_row + 1, end_row + 2, false)[1]
    if is_blank_line(line) then
      break
    end
    end_row = end_row + 1
  end

  local paragraph_lines = {}
  for i = start_row, end_row do
    local line = api.nvim_buf_get_lines(0, i, i + 1, false)[1]:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    if line ~= "" then
      table.insert(paragraph_lines, line)
    end
  end

  local paragraph_text = table.concat(paragraph_lines, " ")
  return paragraph_text, start_row, end_row
end

local function check_sqlite3_available()
  local handle = io.popen(bin_path .. " --version 2>&1")
  if not handle then
    return false, "Failed to execute sqlite3"
  end
  local output = handle:read("*a")
  handle:close()
  return output:find("bit") ~= nil, output
end

local function check_database_exists(db_path)
  local handle = io.popen(bin_path .. ' "' .. db_path .. '" ".quit" 2>&1')
  if not handle then
    return false
  end
  local output = handle:read("*a")
  handle:close()
  return not output:match("unable to open database")
end

local function quote_sql_stmt(stmt)
  if vim.fn.has("win32") == 1 then
    return '"' .. stmt:gsub('"', '\\"') .. '"'
  else
    return "'" .. stmt:gsub("'", "''") .. "'"
  end
end

local execute_sql_at_cursor = function()
  vim.cmd.stopinsert()

  local sql_stmt, para_start_row, para_end_row = get_cursor_paragraph()

  if sql_stmt == "" then
    vim.notify("❌ Cursor paragraph is empty (no SQLite statement)", vim.log.levels.ERROR)
    return
  end

  local sqlite_available, version_msg = check_sqlite3_available()
  if not sqlite_available then
    vim.notify("❌ sqlite3 not available: " .. (version_msg or "unknown error"), vim.log.levels.ERROR)
    return
  end

  local current_db = M.config.databases[M.config.current_db_index]
  if not current_db then
    vim.notify("❌ No database configured", vim.log.levels.ERROR)
    return
  end

  if not check_database_exists(current_db) then
    vim.notify("❌ Database file not found: " .. current_db, vim.log.levels.ERROR)
    return
  end

  local quoted_stmt = quote_sql_stmt(sql_stmt)

  local cmd = {
    bin_path,
    current_db,
    quoted_stmt
  }

  local handle = io.popen(table.concat(cmd, " ") .. " 2>&1", "r")
  if not handle then
    vim.notify("❌ Failed to execute sqlite3 command", vim.log.levels.ERROR)
    return
  end
  local output = handle:read("*a")
  handle:close()

  local result_lines = vim.split(output, "\n", { trimempty = false })
  local insert_lines = { "" }
  for _, line in ipairs(result_lines) do
    table.insert(insert_lines, line)
  end

  local insert_start = para_end_row + 1

  api.nvim_buf_set_lines(
    0,
    insert_start,
    insert_start,
    false,
    insert_lines
  )
end

M.setup = function(user_config)
  if user_config then
    for key, value in pairs(user_config) do
      if key == "databases" then
        M.config.databases = value
      elseif key == "current_db_index" then
        M.config.current_db_index = value
      elseif key == "keymap" then
        M.config.keymap = value
      elseif key == "timeout" then
        M.config.timeout = value
      end
    end
  end
end

M.main = function()
  vim.cmd("botright split")
  local bufnr = api.nvim_create_buf(true, true)
  api.nvim_buf_set_name(bufnr, ("sqlite.nvim://%s"):format(tostring(bufnr)))
  api.nvim_set_option_value("filetype", "sql", {buf = bufnr})
  api.nvim_set_current_buf(bufnr)
  vim.keymap.set({"n", "i"}, M.config.keymap, execute_sql_at_cursor, { nowait = true })
end

M.switch_database = function(index)
  if index and M.config.databases[index] then
    M.config.current_db_index = index
    vim.notify("Switched to database: " .. M.config.databases[index], vim.log.levels.INFO)
  else
    vim.notify("Invalid database index", vim.log.levels.WARN)
  end
end

local function create_database_selector_window()
  vim.cmd("botright split")
  local bufnr = api.nvim_create_buf(false, true)
  local win_id = api.nvim_get_current_win()

  local lines = {"# Select Database (Press <Enter> to select, <Esc> to cancel)", ""}
  for i, db_path in ipairs(M.config.databases) do
    local marker = (i == M.config.current_db_index) and "* " or "  "
    table.insert(lines, marker .. i .. ". " .. db_path)
  end

  api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  api.nvim_buf_set_name(bufnr, "sqlite_nvim://database_selector")
  api.nvim_set_option_value("filetype", "sqlite_nvim_selector", {buf = bufnr})
  api.nvim_set_option_value("modifiable", false, {buf = bufnr})
  api.nvim_set_option_value("buftype", "nofile", {buf = bufnr})

  vim.keymap.set("n", "<CR>", function()
    local cursor_pos = api.nvim_win_get_cursor(win_id)
    local line_num = cursor_pos[1]
    if line_num >= 3 and line_num <= #M.config.databases + 2 then
      local db_index = line_num - 2
      M.switch_database(db_index)
      api.nvim_win_close(win_id, true)
    end
  end, {buffer = bufnr, nowait = true})

  vim.keymap.set("n", "<Esc>", function()
    api.nvim_win_close(win_id, true)
  end, {buffer = bufnr, nowait = true})

  vim.keymap.set("n", "q", function()
    api.nvim_win_close(win_id, true)
  end, {buffer = bufnr, nowait = true})

  return win_id
end

local function create_database_editor_window()
  vim.cmd("botright split")
  local bufnr = api.nvim_create_buf(true, true)
  local win_id = api.nvim_get_current_win()

  local lines = {"# Edit Database List", "# Add new databases below, delete lines to remove", ""}
  for _, db_path in ipairs(M.config.databases) do
    table.insert(lines, db_path)
  end

  api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  api.nvim_buf_set_name(bufnr, "sqlite_nvim://database_editor")
  api.nvim_set_option_value("filetype", "sqlite_nvim_editor", {buf = bufnr})

  local original_databases = vim.deepcopy(M.config.databases)

  vim.keymap.set("n", "<CR>", function()
    local current_lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local new_databases = {}

    for _, line in ipairs(current_lines) do
      if line ~= "" and not line:match("^#") then
        table.insert(new_databases, line)
      end
    end

    local added_dbs = {}
    local removed_dbs = {}

    for _, new_db in ipairs(new_databases) do
      if not vim.tbl_contains(original_databases, new_db) then
        table.insert(added_dbs, new_db)
      end
    end

    for _, old_db in ipairs(original_databases) do
      if not vim.tbl_contains(new_databases, old_db) then
        table.insert(removed_dbs, old_db)
      end
    end

    local message = ""
    if #added_dbs > 0 then
      message = message .. "Add databases:\n" .. table.concat(added_dbs, "\n")
    end
    if #removed_dbs > 0 then
      if message ~= "" then message = message .. "\n\n" end
      message = message .. "Remove databases:\n" .. table.concat(removed_dbs, "\n")
    end
    if message == "" then
      message = "No changes detected"
    end

    vim.ui.input({
      prompt = "Confirm changes? (y/n)\n\n" .. message,
      default = "n"
    }, function(input)
      if input and input:lower() == "y" then
        M.config.databases = new_databases
        if M.config.current_db_index > #new_databases then
          M.config.current_db_index = 1
        end
        vim.notify("Database list updated successfully", vim.log.levels.INFO)
        api.nvim_win_close(win_id, true)
      else
        vim.notify("Changes cancelled", vim.log.levels.WARN)
      end
    end)
  end, {buffer = bufnr, nowait = true})

  vim.keymap.set("n", "<Esc>", function()
    api.nvim_win_close(win_id, true)
  end, {buffer = bufnr, nowait = true})

  vim.keymap.set("n", "q", function()
    api.nvim_win_close(win_id, true)
  end, {buffer = bufnr, nowait = true})

  return win_id
end

M.show_database_selector = function()
  create_database_selector_window()
end

M.edit_database_list = function()
  create_database_editor_window()
end

return M
