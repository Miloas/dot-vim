-- Autocmds are automatically loaded on the VeryLazy event
local function startup()
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = startup })
