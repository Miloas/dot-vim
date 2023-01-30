(module module.binding
  {autoload {nvim     aniseed.nvim
             core     aniseed.core
             util     util
             wk       "which-key"}})

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

(wk.register {:f {:name "file"
                 :f {1 ":lua require'telescope.builtin'.find_files{cwd = vim.fn.systemlist(\"git rev-parse --show-toplevel\")[1]}<CR>" 2 "find file"}
                 :r {1 ":lua require'telescope.builtin'.oldfiles{}<CR>" 2 "recent files"}}
              :b {:name "buffer"
                  :f {1 ":lua require'telescope.builtin'.buffers{}<CR>" 2 "find buffer"}
                  :o {1 ":BufferOrderByBufferNumber<CR>" 2 "order by buffer number"}
                  :p {1 ":bprevious<CR>" 2 "previous buffer"}
                  :n {1 ":bnext<CR>" 2 "next buffer"}
                  :d {1 ":BD<CR>" 2 "delete buffer"}}
              :w {:name "window"
                  :h {1 "<C-W>h" 2 "move left"}
                  :j {1 "<C-W>j" 2 "move down"}
                  :k {1 "<C-W>k" 2 "move up"}
                  :l {1 "<C-W>l" 2 "move right"}
                  :q {1 "<C-W>q" 2 "close window"} ;; window https://www.xsprogram.com/content/vim-close-window-without-closing-buffer.html
                  :- {1 ":split<CR><C-w>j<ESC>" 2 "split horizontal"}
                  :/ {1 ":vsplit<CR><C-w>l<ESC>" 2 "split vertical"}
                  := {1 "<C-w>=" 2 "equalize window sizes"}}
              :t {:name "terminal"
                  :t {1 ":call v:lua.g.toggle_terminal()<CR>" 2 "toggle terminal"}
                  :a {1 ":call v:lua.g.new_terminal()<CR>" 2 "new terminal"}
                  :p {1 ":call v:lua.g.previous_terminal()<CR>" 2 "previous terminal"}
                  :n {1 ":call v:lua.g.next_terminal()<CR>" 2 "next terminal"}}
              :g {:name "git"
                  :s {1 ":LazyGit<CR>" 2 "status"}}
              :p {:name "project"
                  :t {1 ":NvimTreeFindFileToggle<CR>" 2 "toggle tree"}
                  :f {1 ":lua require'telescope.builtin'.git_files{}<CR>" 2 "find file"}
                  :r {1 ":Telescope projects<CR>" 2 "recent project files"}}
              :m {:name "misc"
                  :a {:name "ALE" :f {1 ":ALEFix<CR>" 2 "auto fix"}}
                  :f {1 ":Neoformat<CR>" 2 "format"}
                  :r {1 ":lua require'renamer'.rename{}<CR>" 2 "rename"}}
              :x {:name "trouble"
                  :x {1 ":TroubleToggle<CR>" 2 "toggle"}
                  :w {1 ":TroubleToggle workspace_diagnostics<CR>" 2 "workspace"}
                  :d {1 ":TroubleToggle document_diagnostics<CR>" 2 "document"}
                  :q {1 ":TroubleToggle quickfix<CR>" 2 "quickfix"}
                  :l {1 ":TroubleToggle loclist<CR>" 2 "loclist"}}
              "." {:name "packer"
                   :s {1 ":luafile $MYVIMRC<CR>:PackerSync<CR>" 2 "sync"}}
              "s" {:name "text"
                   :s {1 ":lua require'telescope.builtin'.grep_string{cwd = vim.fn.systemlist(\"git rev-parse --show-toplevel\")[1]}<CR>" 2 "search"}}

              "/" {1 ":lua require'telescope.builtin'.live_grep{ find_command={ 'rg','--hidden','--files','--glob=!.git' }, cwd=vim.fn.systemlist(\"git rev-parse --show-toplevel\")[1]}<CR>" 2 "search"}
              "<leader>" {1 ":lua require('legendary').find('commands')<CR>" 2 "commands"}
              } {:prefix "<leader>"})

(wk.register {:gd {1 ":lua vim.lsp.buf.definition()<CR>" 2 "goto definition"} 
              :gr {1 ":lua require'telescope.builtin'.lsp_references{}<CR>" 2 "list references"}
              :gR {1 ":TroubleToggle lsp_references<CR>" 2 "troubleToggle references"}
              :gt {1 ":lua require'telescope.builtin'.lsp_type_definitions{}<CR>" 2 "list type definitions"}
              :gi {1 ":lua require'telescope.builtin'.lsp_implementations{}<CR>" 2 "list implementations"}
              :ga {1 ":lua require'telescope.builtin'.lsp_document_symbols{}<CR>" 2 "list document symbols"}

              :ge {1 ":ALEDetail<CR>" 2 "detail err"}
              "]q" {1 ":ALENext<CR>" 2 "next err"}
              "[q" {1 ":ALEPrevious<CR>" 2 "previous err"}
              
              :co {1 ":GitConflictChooseOurs<CR>" 2 "conflict choose ours"}
              :ct {1 ":GitConflictChooseTheirs<CR>" 2 "conflict choose theirs"}
              :cb {1 ":GitConflictChooseBoth<CR>" 2 "conflict choose both"}
              :c0 {1 ":GitConflictChooseNone<CR>" 2 "conflict choose none"}
              "]x" {1 ":GitConflictNextConflict<CR>" 2 "next conflict"}
              "[x" {1 ":GitConflictPrevConflict<CR>" 2 "previous conflict"}})

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
(defmap [n v] :<C-.> ":CodeActionMenu<CR>")

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

;; V ;;
;;;;;;;
(defmap [v] ";" ":Commentary<CR>" {:silent true})
(defmap [n] "<leader>;;" ":Commentary<CR>" {:silent true})

;; NATIVE COPY/PASTE ;;
;;;;;;;;;;;;;;;;;;;;;;;
;; https://github.com/neovide/neovide/issues/295
(defmap [n] :+y "\"+y" {:noremap true})
(defmap [n] :+p "\"+p" {:noremap true})
(defmap [n] :+d "\"+d" {:noremap true})
(defmap [n] :*y "\"*y" {:noremap true})
(defmap [n] :*p "\"*p" {:noremap true})
(defmap [n] :*d "\"*d" {:noremap true})

;; MOVE ;;
;;;;;;;;;;
;; https://github.com/neovide/neovide/issues
(defmap [n] :∆ ":MoveLine(1)<CR>" {:noremap true :silent true})
(defmap [n] :˚ ":MoveLine(-1)<CR>" {:noremap true :silent true})
(defmap [v] :∆ ":MoveBlock(1)<CR>" {:noremap true :silent true})
(defmap [v] :˚ ":MoveBlock(-1)<CR>" {:noremap true :silent true})
