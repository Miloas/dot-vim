(module module.settings
  {require {core aniseed.core
            telescope telescope
            project project_nvim
            util util}})

(vim.cmd "filetype plugin indent on")
(vim.cmd "autocmd BufEnter * silent! lcd &:p:h")

;; Telescope
(telescope.load_extension "projects")

;; Projects
(project.setup {})

;; Airline
(set vim.g.airline_powerline_fonts 1)
(set vim.g.airline_section_z "%3l/%L:%3v")
(set vim.g.airline_left_sep "")
(set vim.g.airline_right_sep "")
(set vim.g.airline#extensions#coc#enabled 1)
(set vim.g.airline_section_warning "")
(set vim.g.airline_section_error "")

;; Colors
(vim.cmd "colorscheme gruvbox")
(set vim.g.gruvbox_invert_selection 1)

;; Terminal
(set vim.g.floaterm_winblend 20)
(set vim.g.floaterm_position "center")

;; Neovide
(set vim.g.neovide_refresh_rate 150)
;; (set vim.g.neovide_cursor_animate_in_insert_mode 0)

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

(defn set-option [option]
  (vim.cmd (.. "set " option)))

(set-option :nonumber)
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
