(module module.bindings
  {require {nvim     aniseed.nvim
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
  {:v {:name "Vim"
       :i [":luafile $MYVIMRC<CR>:PaqInstall<CR>" "install"]
       :u [":luafile $MYVIMRC<CR>:PaqUpdate<CR>" "update"]
       :c [":luafile $MYVIMRC<CR>:PaqClean<CR>" "clean unused"]
       :e {:name "Edit"
           :I [":e $MYVIMRC<CR>" "init.lua (bootstrap)"]
           :i [":e $MYVIMRC/../fnl/init.fnl<CR>" "init.fnl"]
           :b [":e $MYVIMRC/../fnl/module/bindings.fnl<CR>" "bindings.fnl"]
           :p [":e $MYVIMRC/../fnl/module/plugins.fnl<CR>" "plugins.fnl"]
           :s [":e $MYVIMRC/../fnl/module/settings.fnl<CR>" "settings.fnl"]
           :l [":e $MYVIMRC/../fnl/module/lsp.fnl<CR>" "lsp.fnl"]}}
   :q {:name "Quit"
       :q [":wqall<CR>" "quit and save everything"]
       :r [":Obsession ~/session.vim<CR>:!start neovide -S ~/session.vim<CR><CR>:wqall<CR>" "quit and reload"]}
  ;; window https://www.xsprogram.com/content/vim-close-window-without-closing-buffer.html
   :w {:name "Windows"
       :h ["<C-w>h" "jump left"]
       :j ["<C-w>j" "jump down"]
       :k ["<C-w>k" "jump up"]
       :l ["<C-w>l" "jump right"]
      ;;  :y [":vsplit<CR><ESC>" "split left"]
       :- [":split<CR><C-w>j<ESC>" "split down"]
      ;;  :i [":split<CR><ESC>" "split up"]
       :/ [":vsplit<CR><C-w>l<ESC>" "split right"]
       := ["<C-w>=" "auto resize"]}
   :b {:name "Buffers"
       :o [":BufferOrderByBufferNumber<CR>" "order buffers"]
       :p [":bprevious<CR>" "previous"]
       :n [":bnext<CR>" "next"]
      ;;  :k [":bfirst<CR>" "first"]
      ;;  :j [":blast<CR>" "last"]
       :d [":BD<CR>" "delete"]}
   :f {:name "Files"
       :f [":Telescope find_files<CR>" "find files"]
       :b [":Telescope buffers<CR>" "find buffers"]
      ;;  :h [":Telescope help_tags<CR>" "help tags"]
       :r [":lua require'telescope.builtin'.oldfiles{}<CR>" "recent"]
       :s [":w<CR>" "save"]}
   :t {:name "Terminal"
       :t ["<ESC>:call v:lua.g.toggle_terminal()<CR>" "Open Terminal"]
       :n ["<ESC>:call v:lua.g.new_terminal()<CR>" "New Terminal"]
       :l ["<ESC>:call v:lua.g.next_terminal()<CR>" "Next Terminal"]
       :h ["<ESC>:call v:lua.g.previous_terminal()<CR>" "Previous Terminal"]}
   :s {:name "String"
       :s [":Telescope grep_string<CR>" "grep string"]}
   :p {:name "Project"
       :t [":Telescope file_browser<CR>" "files tree"]
       :f [":lua require('telescope.builtin').file_browser({cwd = vim.fn.expand('%:p:h')})<CR>" "current dir"]}
   ";" {:name "Comments"
       ";" [":Commentary<CR>" "current line"]}}
  {:prefix "<leader>"})

;; search ;;
;;;;;;;;;;;;
(noremap-silent :n "<leader>/" ":Telescope live_grep<CR>")

;; File ;;
;;;;;;;;;;
;; (noremap-silent :n "<leader>pf" ":CHADopen<CR>")


;; Buffer ;;
;;;;;;;;;;;;
;; https://github.com/romgrk/barbar.nvim
(noremap-silent :n "<leader><Tab>" ":bprevious<CR>")
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
(map-silent :n "<C-.>" ":lua vim.lsp.buf.code_action()<CR>")
(map-silent :v "<C-.>" ":lua vim.lsp.buf.code_action()<CR>")

;; COQ ;;
;;;;;;;;;
(noremap-silent-expr :i "<Esc>" "pumvisible() ? '<C-e><Esc>' : '<Esc>'")
(noremap-silent-expr :i "<C-c>" "pumvisible() ? '<C-e><C-c>' : '<C-c>'")
(noremap-silent-expr :i "<BS>" "pumvisible() ? '<C-e><BS>' : '<BS>'")
(noremap-silent-expr :i "<Tab>" "pumvisible() ? '<cr>' : '<Tab>'")

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
