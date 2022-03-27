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

(whichkey.register
  {:. {:name "Packer"
       :s [":luafile $MYVIMRC<CR>:PackerSync<CR>" "sync plugins"]}
  ;; window https://www.xsprogram.com/content/vim-close-window-without-closing-buffer.html
   :w {:name "Windows"
       :h ["<C-w>h" "jump left"]
       :j ["<C-w>j" "jump down"]
       :k ["<C-w>k" "jump up"]
       :l ["<C-w>l" "jump right"]
       :q ["<C-w>q" "close current"]
      ;;  :y [":vsplit<CR><ESC>" "split left"]
       :- [":split<CR><C-w>j<ESC>" "split down"]
      ;;  :i [":split<CR><ESC>" "split up"]
       :/ [":vsplit<CR><C-w>l<ESC>" "split right"]
       := ["<C-w>=" "auto resize"]}
   :b {:name "Buffers"
       :o [":BufferOrderByBufferNumber<CR>" "order buffers"]
       :p [":bprevious<CR>" "previous"]
       :n [":bnext<CR>" "next"]
       :d [":BD<CR>" "delete"]}
   :f {:name "Files"
       :f [":lua require'telescope.builtin'.find_files{}<CR>" "find files"]
       :b [":lua require'telescope.builtin'.buffers{}<CR>" "find buffers"]
       :r [":lua require'telescope.builtin'.oldfiles{}<CR>" "find recent files"]}
   :t {:name "Terminal"
       :t ["<ESC>:call v:lua.g.toggle_terminal()<CR>" "Open Terminal"]
       :a ["<ESC>:call v:lua.g.new_terminal()<CR>" "New Terminal"]
       :n ["<ESC>:call v:lua.g.next_terminal()<CR>" "Next Terminal"]
       :p ["<ESC>:call v:lua.g.previous_terminal()<CR>" "Previous Terminal"]}
   :s {:name "String"
       :s [":lua require'telescope.builtin'.grep_string{}<CR>" "grep string"]}
   :g {:name "git"
       :s [":LazyGit<CR>" "lazygit"]}
   :p {:name "Project"
       :t [":NvimTreeFindFileToggle<CR>" "files tree"]
       :f [":lua require'telescope.builtin'.find_files{ find_command={ 'rg','--hidden','--files','--glob=!.git' }}<CR>" "find files"]
       :r [":Telescope projects<CR>" "recent projects"]}
   :m {:name "Editor"
       :f [":Neoformat<CR>" "format"]
       :r [":lua require'renamer'.rename{}<CR>" "rename"]}  
        :a {:name "Ale" 
       :f [":ALEFix<CR>" "fixer"]}
   :x {:name "Trouble" 
       :x [":TroubleToggle<CR>" "toggle"]
       :w [":TroubleToggle workspace_diagnostics<CR>" "toggle workspace"]
       :d [":TroubleToggle document_diagnostics<CR>" "toggle document"]
       :q [":TroubleToggle quickfix<CR>" "toggle quickfix"]
       :l [":TroubleToggle loclist<CR>" "toggle loclist"]}
   ";" {:name "Comments"
       ";" [":Commentary<CR>" "current line"]}}
  {:prefix "<leader>"})

;; Search ;;
;;;;;;;;;;;;
(defmap [n] :<leader>/ ":Telescope live_grep<CR>" {:silent true})

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
(defmap [n] :gh ":lua vim.lsp.buf.hover()<CR>" {:silent true})
(defmap [n] :gd ":lua vim.lsp.buf.definition()<CR>" {:silent true})
(defmap [n] :gr ":lua require'telescope.builtin'.lsp_references{}<CR>" {:silent true})
(defmap [n] :gR ":TroubleToggle lsp_references<CR>" {:silent true})
(defmap [n] :gt ":lua require'telescope.builtin'.lsp_type_definitions{}<CR>" {:silent true})
(defmap [n] :gi ":lua require'telescope.builtin'.lsp_implementations{}<CR>" {:silent true})
(defmap [n] :ga ":lua require'telescope.builtin'.lsp_document_symbols{}<CR>" {:silent true})
(map-silent :n "<C-.>" ":CodeActionMenu<CR>")
(map-silent :v "<C-.>" ":CodeActionMenu<CR>")

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

;; ALE
(defmap [n] "]q" ":ALENext<CR>" {:silent true})
(defmap [n] "[q" ":ALEPrevious<CR>" {:silent true})
(defmap [n] :ge ":ALEDetail<CR>" {:silent true})

;; V
(defmap [v] ";" ":Commentary<CR>" {:silent true})
