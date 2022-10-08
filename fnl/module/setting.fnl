(module module.setting
  {autoload {core aniseed.core
             cmp cmp
             util util}})

(vim.cmd "filetype plugin indent on")
(vim.cmd "autocmd BufEnter * silent! lcd &:p:h")

;; https://github.com/f-person/git-blame.nvim
(set vim.g.gitblame_enabled 0)

;; Colors
(vim.cmd "colorscheme gruvbox")

;; Terminal
(set vim.g.floaterm_winblend 20)
(set vim.g.floaterm_position "center")

;; Neovide
(set vim.g.neovide_refresh_rate 150)
(set vim.g.neovide_cursor_animate_in_insert_mode 0)

;; Options
(set vim.o.guifont "JetBrainsMono Nerd Font:h15")
(set vim.o.winblend 20)
(set vim.o.pumblend 20)
(set vim.o.ve "block")
(set vim.o.mouse "a")
(set vim.o.clipboard "unnamed")
(set vim.o.timeoutlen 500)
(set vim.o.textwidth 120)
(set vim.o.conceallevel 3)
(set vim.o.background "dark")

(defn set-option [option]
  (vim.cmd (.. "set " option)))

;; (set-option :nonumber)
(set-option :number)
(set-option :cursorline)
(set-option :termguicolors)
(set-option :expandtab)
(set-option :hlsearch)
(set-option :ignorecase)
(set-option :smartcase)
(set-option :noshowmode)
(set-option :hidden)
(set-option :nowrap)

(set vim.o.smartindent true)
(set vim.o.expandtab true)
(set vim.o.shiftwidth 2)
(set vim.o.tabstop 2)

(vim.api.nvim_set_hl 0 "CursorLineNr" {:bg "none"})

(set vim.opt.signcolumn "yes")
