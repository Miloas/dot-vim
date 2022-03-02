(module module.binding
  {autoload {nvim     aniseed.nvim
             core     aniseed.core
             util     util
             whichkey "which-key"}})

;; Utils ;;
;;;;;;;;;;;
(defn- map [mode from to]
  "Sets a mapping"
  (nvim.set_keymap mode from to {}))

(defn- map-silent [mode from to]
  "Sets a mapping with {:silent true}"
  (nvim.set_keymap mode from to {:silent true}))

(defn- noremap [mode from to]
  "Sets a mapping with {:noremap true}"
  (nvim.set_keymap mode from to {:noremap true}))

(defn- noremap-silent [mode from to]
  "Sets a mapping with {:noremap true :silent true}"
  (nvim.set_keymap mode from to {:noremap true :silent true}))

(defn- noremap-silent-expr [mode from to]
  "Sets a mapping with {:noremap true :silent true :expr true}"
  (nvim.set_keymap mode from to {:noremap true :silent true :expr true}))

(defn- noremap-silent-script-expr [mode from to]
  "Sets a mapping with {:noremap true :silent true :expr true :script true}"
  (nvim.set_keymap mode from to {:noremap true :silent true :expr true :script true}))

(defn- noremap-expr [mode from to]
  "Sets a mapping with {:noremap true :expr true}"
  (nvim.set_keymap mode from to {:noremap true :expr true}))

(defn- declare-command [body]
  (nvim.command (.. "command! " body)))

(defn- declare-command-with-args [body]
  (nvim.command (.. "command! -nargs=+ " body)))

(defn- is-terminal-buffer [bufnumber]
  (and (= (. nvim.bo bufnumber "buftype") "terminal") 
       (= (. nvim.b bufnumber "floaterm_window") 1)))

(defn- is-terminal-window [winnr]
  (is-terminal-buffer (nvim.fn.winbufnr winnr)))

(defn- find-terminal-window []
  (core.first 
    (core.filter 
      is-terminal-window
      (nvim.fn.range 1 (nvim.fn.winnr "$")))))
(util.export :find_terminal_window find-terminal-window)

(defn hide-terminal []
  (let [winnr (find-terminal-window)]
    (if (not (core.nil? winnr))
      (nvim.command (.. winnr " wincmd q")))))
(util.export :hide_terminal hide-terminal)

(defn setup-terminal []
  (tset nvim.g "floaterm_width" (- (. nvim.o "columns") 10))
  (tset nvim.g "floaterm_height" (- (. nvim.o "lines") 5)))

(defn toggle-terminal []
  (setup-terminal)
  (set nvim.o.shell "zsh")
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
   :j {:name "Hop"
       :w [":HopWord<CR>" "jump word"]
       :j [":HopLine<CR>" "jump line"]}
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
       :t [":NvimTreeToggle<CR>" "files tree"]
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
(noremap-silent :n "<leader>/" ":Telescope live_grep<CR>")

;; Buffer ;;
;;;;;;;;;;;;
;; https://github.com/romgrk/barbar.nvim
(noremap-silent :n "<leader><Tab>" "<C-^>")
(noremap-silent :n "<leader>0" ":NvimTreeFocus<CR>")
(noremap-silent :n "<leader>1" ":BufferGoto 1<CR>")
(noremap-silent :n "<leader>2" ":BufferGoto 2<CR>")
(noremap-silent :n "<leader>3" ":BufferGoto 3<CR>")
(noremap-silent :n "<leader>4" ":BufferGoto 4<CR>")
(noremap-silent :n "<leader>5" ":BufferGoto 5<CR>")
(noremap-silent :n "<leader>6" ":BufferGoto 6<CR>")
(noremap-silent :n "<leader>7" ":BufferGoto 7<CR>")
(noremap-silent :n "<leader>8" ":BufferGoto 8<CR>")
(noremap-silent :n "<leader>9" ":BufferGoto 9<CR>")
(noremap-silent :n "<C-x>1" "<C-w>o")

;;  LSP  ;;
;;;;;;;;;;;
(noremap-silent :n "gh" ":lua vim.lsp.buf.hover()<CR>")
(noremap-silent :n "gd" ":lua vim.lsp.buf.definition()<CR>")
(noremap-silent :n "gr" ":lua require'telescope.builtin'.lsp_references{}<CR>")
(noremap-silent :n "gR" ":TroubleToggle lsp_references<CR>")
(noremap-silent :n "gt" ":lua require'telescope.builtin'.lsp_type_definitions{}<CR>")
(noremap-silent :n "gi" ":lua require'telescope.builtin'.lsp_implementations{}<CR>")
(noremap-silent :n "ga" ":lua require'telescope.builtin'.lsp_document_symbols{}<CR>")
(map-silent :n "<C-.>" ":CodeActionMenu<CR>")
(map-silent :v "<C-.>" ":CodeActionMenu<CR>")
; (map-silent :n "<C-.>" ":lua vim.lsp.buf.code_action()<CR>")
; (map-silent :v "<C-.>" ":lua vim.lsp.buf.code_action()<CR>")

;; VISUAL ;;
;;;;;;;;;;;;
(noremap-silent :v "<" "<gv")
(noremap-silent :v ">" ">gv")
(noremap-silent :v ";" ":Commentary<CR>")
(noremap-silent :v "<M-q>" "gq")

;; TERMINAL ;;
;;;;;;;;;;;;;;
(noremap-silent :t "<ESC>" "<C-\\><C-n>")

;; SCROLLING ;;
;;;;;;;;;;;;;;;
(noremap-silent :n "<down>" ":call comfortable_motion#flick(100)<CR>")
(noremap-silent :n "<up>" ":call comfortable_motion#flick(-100)<CR>")

;; GENERAL ;;
;;;;;;;;;;;;;
(noremap-silent :n "-" ":Balsamic<CR>")
(map-silent :n "<ESC>" ":noh<CR>:call v:lua.g.hide_terminal()<CR>")
(noremap-silent :i "<C-A>" "<Home>")
(noremap-silent :i "<C-B>" "<Left>")

;; may conflict with lsp automation cancel
(noremap-silent :i "<C-E>" "<End>")
(noremap-silent :i "<C-F>" "<Right>")

;; ALE
(noremap-silent :n "]q" ":ALENext<CR>")
(noremap-silent :n "[q" ":ALEPrevious<CR>")
(noremap-silent :n "ge" ":ALEDetail<CR>")