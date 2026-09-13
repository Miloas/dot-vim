-- Autocmds are automatically loaded on the VeryLazy event

-- Open the file tree on startup, but keep the cursor in the file you opened.
-- `tree.open()` always focuses the tree; `toggle` honours `focus = false` and
-- restores the previous window.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.toggle({ focus = false })
  end,
})
