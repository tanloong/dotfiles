if vim.fn.has "win32" == 1 then
  -- 在 Windows 上打开当前文件目录
  vim.keymap.set("n", "<space>fe", function()
    local cwd = vim.fn.expand "%:p:h"
    local cmd = { "cmd.exe", "/c", "start", cwd }
    vim.system(cmd, {
      detach = true,
      text = true,
    })
  end, {
    noremap = true,
    silent = true,
    desc = "Open Windows File Explorer at CWD (non-blocking, vim.system)"
  })
end
