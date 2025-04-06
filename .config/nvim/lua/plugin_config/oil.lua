require "oil".setup {
  skip_confirm_for_simple_edits = true,
  -- columns = { "size", "mtime" },
  columns = {},
  float = { border = "single", },
  keymaps = {
    ["g?"] = { "actions.show_help", mode = "n" },
    ["<c-l>"] = "actions.select",
    -- ["<C-s>"] = { "actions.select", opts = { vertical = true } },
    -- ["<C-s>"] = { "actions.select", opts = { vertical = true } },
    -- ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
    ["<C-t>"] = { "actions.select", opts = { tab = true } },
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = { "actions.close", mode = "n" },
    ["R"] = "actions.refresh",
    ["<c-h>"] = { "actions.parent", mode = "n" },
    ["_"] = { "actions.open_cwd", mode = "n" },
    ["`"] = { "actions.cd", mode = "n" },
    ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
    ["gs"] = { "actions.change_sort", mode = "n" },
    ["gx"] = "actions.open_external",
    ["zh"] = { "actions.toggle_hidden", mode = "n" },
    ["g\\"] = { "actions.toggle_trash", mode = "n" },
    ["yp"] = { "actions.copy_entry_path", mode = "n" },
    ["yb"] = function()
      local entry = require "oil".get_cursor_entry()
      if not entry then
        vim.notify("Invalid entry!", vim.log.levels.ERROR); return
      end
      vim.fn.setreg("+", entry.name)
    end
  },
  use_default_keymaps = false,
}
vim.keymap.set("n", "<c-h>", "<CMD>Oil<CR>", { desc = "Open parent directory" })
