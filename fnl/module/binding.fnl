(module module.binding
  {autoload {nvim     aniseed.nvim
             core     aniseed.core
             util     util
             whichkey "which-key"}})

(import-macros {: defmap } :macros)

;; Utils ;;
;;;;;;;;;;;
(defn- declare-command [body]
  (nvim.command (.. "command! " body)))

(defn- declare-command-with-args [body]
  (nvim.command (.. "command! -nargs=+ " body)))

(defn hide-terminal []
  (nvim.ex.FloatermHide))
(util.export :hide_terminal hide-terminal)

(defn setup-terminal []
  (tset nvim.g "floaterm_width" (- (. nvim.o "columns") 10))
  (tset nvim.g "floaterm_height" (- (. nvim.o "lines") 5)))

(defn toggle-terminal []
  (setup-terminal)
  (nvim.ex.FloatermToggle)
  (set nvim.o.shell "zsh"))
(util.export :toggle_terminal toggle-terminal)

(defn new-terminal []
  (setup-terminal)
  (set nvim.o.shell "zsh")
  (nvim.ex.FloatermNew)
  (set nvim.o.shell "zsh"))
(util.export :new_terminal new-terminal)

(defn next-terminal []
  (setup-terminal)
  (nvim.ex.FloatermNext))
(util.export :next_terminal next-terminal)

(defn previous-terminal []
  (setup-terminal)
  (nvim.ex.FloatermPrev))
(util.export :previous_terminal previous-terminal)

;; LEADER ;;
;;;;;;;;;;;;
(set nvim.g.mapleader " ")
(set nvim.g.maplocalleader ",")

;; Terminal ;;
;;;;;;;;;;;;;;
(defmap [n] :<leader>tt "<ESC>:call v:lua.g.toggle_terminal()<CR>" {:silent true})
(defmap [n] :<leader>ta "<ESC>:call v:lua.g.new_terminal()<CR>" {:silent true})
(defmap [n] :<leader>tp "<ESC>:call v:lua.g.previous_terminal()<CR>" {:silent true})
(defmap [n] :<leader>tn "<ESC>:call v:lua.g.next_terminal()<CR>" {:silent true})

;; Window ;;
;;;;;;;;;;;;
(defmap [n] :<leader>wh "<C-W>h" {:silent true})
(defmap [n] :<leader>wj "<C-W>j" {:silent true})
(defmap [n] :<leader>wk "<C-W>k" {:silent true})
(defmap [n] :<leader>wl "<C-W>l" {:silent true})
;; window https://www.xsprogram.com/content/vim-close-window-without-closing-buffer.html
(defmap [n] :<leader>wq "<C-W>q" {:silent true})
(defmap [n] :<leader>w- ":split<CR><C-w>j<ESC>" {:silent true})
(defmap [n] :<leader>w/ ":vsplit<CR><C-w>l<ESC>" {:silent true})
(defmap [n] :<leader>w= "<C-w>=" {:silent true})

;; Buffer ;;
;;;;;;;;;;;;
(defmap [n] :<leader>bo ":BufferOrderByBufferNumber<CR>" {:silent true})
(defmap [n] :<leader>bp ":bprevious<CR>" {:silent true})
(defmap [n] :<leader>bn ":bnext<CR>" {:silent true})
(defmap [n] :<leader>bd ":BD<CR>" {:silent true})

;; Find ;;
;;;;;;;;;;
(defmap [n] :<leader>ff ":lua require'telescope.builtin'.find_files{cwd = vim.fn.systemlist(\"git rev-parse --show-toplevel\")[1]}<CR>" {:silent true})
(defmap [n] :<leader>fb ":lua require'telescope.builtin'.buffers{}<CR>" {:silent true})
(defmap [n] :<leader>fr ":lua require'telescope.builtin'.oldfiles{}<CR>" {:silent true})

;; Git ;;
;;;;;;;;;
(defmap [n] :<leader>gs ":LazyGit<CR>" {:silent true})

;; Project ;;
;;;;;;;;;;;;;
(defmap [n] :<leader>pt ":NvimTreeFindFileToggle<CR>" {:silent true})
(defmap [n] :<leader>pf ":lua require'telescope.builtin'.git_files{}<CR>" {:silent true})
(defmap [n] :<leader>pr ":Telescope projects<CR>" {:silent true})

;; General ;;
(defmap [n] :<leader>mf ":Neoformat<CR>" {:silent true})
(defmap [n] :<leader>mr "<Plug>(coc-rename)" {:silent true})

;; Trouble ;;
;;;;;;;;;;;;;
(defmap [n] :<leader>xx ":TroubleToggle<CR>" {:silent true})
(defmap [n] :<leader>xw ":TroubleToggle workspace_diagnostics<CR>" {:silent true})
(defmap [n] :<leader>xd ":TroubleToggle document_diagnostics<CR>" {:silent true})
(defmap [n] :<leader>xq ":TroubleToggle quickfix<CR>" {:silent true})
(defmap [n] :<leader>xl ":TroubleToggle loclist<CR>" {:silent true})

;; Packer ;;
;;;;;;;;;;;;
(defmap [n] :<leader>.s ":luafile $MYVIMRC<CR>:PackerSync<CR>" {:silent true})

;; Search ;;
;;;;;;;;;;;;
(defmap [n] :<leader>/ ":lua require'telescope.builtin'.live_grep{ find_command={ 'rg','--hidden','--files','--glob=!.git' }, cwd=vim.fn.systemlist(\"git rev-parse --show-toplevel\")[1]}<CR>" {:silent true})
(defmap [n] :<leader>ss ":lua require'telescope.builtin'.grep_string{cwd = vim.fn.systemlist(\"git rev-parse --show-toplevel\")[1]}<CR>" {:silent true})

;; Buffer ;;
;;;;;;;;;;;;
;; https://github.com/romgrk/barbar.nvim
(defmap [n] :<leader><Tab> "<C-^>" {:silent true})
(defmap [n] :<leader>0 ":NvimTreeFindFile<CR>" {:silent true})
(defmap [n] :<leader>1 ":BufferGoto 1<CR>" {:silent true})
(defmap [n] :<leader>2 ":BufferGoto 2<CR>" {:silent true})
(defmap [n] :<leader>3 ":BufferGoto 3<CR>" {:silent true})
(defmap [n] :<leader>4 ":BufferGoto 4<CR>" {:silent true})
(defmap [n] :<leader>5 ":BufferGoto 5<CR>" {:silent true})
(defmap [n] :<leader>6 ":BufferGoto 6<CR>" {:silent true})
(defmap [n] :<leader>7 ":BufferGoto 7<CR>" {:silent true})
(defmap [n] :<leader>8 ":BufferGoto 8<CR>" {:silent true})
(defmap [n] :<leader>9 ":BufferGoto 9<CR>" {:silent true})
(defmap [n] :<C-X>1 "<C-w>o" {:silent true})

;;  LSP  ;;
;;;;;;;;;;;
(defmap [i] :<C-J>
            "pumvisible() ? \"\\<C-N>\" : \"\\<C-J>\""
            {:noremap true :expr true :silent true})
(defmap [i] :<C-K>
            "pumvisible() ? \"\\<C-P>\" : \"\\<C-K>\""
            {:noremap true :expr true :silent true})
(defmap [i] :<TAB>
            "pumvisible() ? \"\\<C-Y>\" : \"\\<Tab>\""
            {:noremap true :expr true :silent true})
(defmap [n] :gd "<Plug>(coc-definition)" {:silent true})
(defmap [n] :gD "<Plug>(coc-type-definition)" {:silent true})
(defmap [n] :gi "<Plug>(coc-implementation)" {:silent true})
(defmap [n] :gr "<Plug>(coc-references)" {:silent true})
(defmap [n] :gh ":call CocActionAsync(\'doHover\')<CR>" {:silent true})
(defmap [n v] :<C-.> ":CodeActionMenu<CR>" {:silent true})

;; TERMINAL ;;
;;;;;;;;;;;;;;
(defmap [t] :<ESC> "<C-\\><C-n>" {:silent true})
(defmap [n] :<ESC> ":call v:lua.g.hide_terminal()<CR>" {:silent true})

;; GENERAL ;;
;;;;;;;;;;;;;
(defmap [i] :<C-A> "<Home>" {:silent true})
(defmap [i] :<C-B> "<Left>" {:silent true})
;; conflict with copilot
(defmap [i] :<C-E> "<End>" {:silent true})
(defmap [i] :<C-F> "<Right>" {:silent true})
(defmap [n] :<leader><leader> ":lua require('legendary').find('commands')<CR>" {:silent true})

;; ALE ;;
;;;;;;;;;
(defmap [n] "]q" ":ALENext<CR>" {:silent true})
(defmap [n] "[q" ":ALEPrevious<CR>" {:silent true})
(defmap [n] :ge ":ALEDetail<CR>" {:silent true})
(defmap [n] :<leader>af ":ALEFix<CR>" {:silent true})

;; V ;;
;;;;;;;
(defmap [v] ";" ":Commentary<CR>" {:silent true})
(defmap [n] "<leader>;;" ":Commentary<CR>" {:silent true})

;; Copilot ;;
;;;;;;;;;;;;;
(defmap [i] :<C-E> "copilot#Accept(\"<CR>\")" {:silent true :script true :expr true})

;; NATIVE COPY/PASTE ;;
;;;;;;;;;;;;;;;;;;;;;;;
;; https://github.com/neovide/neovide/issues/295
(defmap [n] :+y "\"+y" {:noremap true})
(defmap [n] :+p "\"+p" {:noremap true})
(defmap [n] :+d "\"+d" {:noremap true})
(defmap [n] :*y "\"*y" {:noremap true})
(defmap [n] :*p "\"*p" {:noremap true})
(defmap [n] :*d "\"*d" {:noremap true})
(defmap [n] :<C-C> "\"+y")
(defmap [n] :<C-V> "\"+p")
(defmap [c] :<C-V> "<C-R>+")