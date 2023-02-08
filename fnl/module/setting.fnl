(module module.setting
  {autoload {core aniseed.core
             cmp cmp
             util util}})

(import-macros {: let!
                : set!} :macros)

(vim.cmd "filetype plugin indent on")
(vim.cmd "autocmd BufEnter * silent! lcd &:p:h")

;; Colors
(vim.cmd "colorscheme tokyonight")

;; Terminal
(let! floaterm_winblend 20)
(let! floaterm_position "center")

;; Neovide
(let! neovide_refresh_rate 150)
(let! neovide_cursor_animate_in_insert_mode 0)

;; Options
(set! :guifont "JetBrainsMono Nerd Font:h15")
(set! :winblend 20)
(set! :pumblend 20)
(set! :ve "block")
(set! :mouse "a")
(set! :clipboard "unnamed")
(set! :timeoutlen 300)
(set! :textwidth 120)
(set! :conceallevel 3)
(set! :background "dark")
(set! :smartindent true)
(set! :expandtab true)
(set! :shiftwidth 2)
(set! :tabstop 2)
(set! :signcolumn "yes")
; (set vim.o.fillchars "vert:▏")

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

(vim.api.nvim_set_hl 0 "CursorLineNr" {:bg "none"})
