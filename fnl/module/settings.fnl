(module module.settings
  {require {core aniseed.core
            telescope telescope
            project project_nvim
            subs substitute
            hop hop
            renamer renamer
            npairs nvim-autopairs
            cmp_autopairs nvim-autopairs.completion.cmp
            cmp cmp
            ncmp_lsp cmp_nvim_lsp
            lsp lspconfig
            luasnip luasnip
            treesitter-config nvim-treesitter.configs
            util util}})

(vim.cmd "filetype plugin indent on")
(vim.cmd "autocmd BufEnter * silent! lcd &:p:h")

;; nvim-cmp
(let [capabilities (vim.lsp.protocol.make_client_capabilities {})]
  (ncmp_lsp.update_capabilities capabilities)
  (lsp.gopls.setup {:capabilities capabilities})
  (lsp.rust_analyzer.setup {:capabilities capabilities})
  (lsp.pyright.setup {:capabilities capabilities})
  (lsp.tsserver.setup {:capabilities capabilities}))

(cmp.setup {:snippet {:expand (fn [args] (luasnip.lsp_expand args.body))}
            :mapping {:<C-K> (cmp.mapping.select_prev_item {})
                      :<C-J> (cmp.mapping.select_next_item {})
                      :<C-D> (cmp.mapping.scroll_docs -4)
                      :<C-F> (cmp.mapping.scroll_docs 4)
                      :<C-Space> (cmp.mapping.complete {})
                      :<C-E> (cmp.mapping.close {})
                      :<Tab> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Replace
                                                   :select true})}
            :sources [{:name "nvim_lsp"} {:name "luasnip"}]})

;; autopairs
(npairs.setup {})
(cmp.event:on "confirm_done" (cmp_autopairs.on_confirm_done {:map_char {:tex ""}}))

;; Telescope
(telescope.load_extension "projects")
(telescope.load_extension "file_browser")

;; treesitter
(treesitter-config.setup 
  {:ensure_installed "maintained"
   :sync_install false
   :highlight {:enable true
               :additional_vim_regex_highlighting false}})

;; Projects
(project.setup {})

;; Renamer
(renamer.setup {})

;; Motion
(subs.setup {})
(hop.setup {})

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