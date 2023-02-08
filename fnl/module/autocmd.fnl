(fn open-nvim-tree []
  (local api (require :nvim-tree.api))
  (api.tree.open {}))

(vim.api.nvim_create_autocmd ["VimEnter"] {:callback open-nvim-tree})
