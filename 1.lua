local ns_id = vim.api.nvim_create_namespace('myplugin')
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local function round(n)
    return math.floor(n + 0.5)
end

local function update_scrollbar()
    local top_line = vim.fn.line("w0")
    local win_h = vim.api.nvim_win_get_height(0)
    local total_lines = vim.fn.line("$") - win_h
    local linenr = round((win_h * top_line / total_lines)) + top_line - 1
    linenr = math.min(linenr, total_lines)
    local opts = {
        id = 1,
        end_line = linenr,
        virt_text = { { "█", "Cursor" } },
        virt_text_pos = "right_align",
        ephemeral = false,
    }
    local mark_id = vim.api.nvim_buf_set_extmark(0, ns_id, linenr, -1, opts)
end

autocmd({ "WinScrolled" }, {
    pattern = "*",
    group = augroup("scrollbar", { clear = true }),
    callback = update_scrollbar,
}) -- }}}
