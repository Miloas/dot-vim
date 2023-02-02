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
                 :f [":lua require'telescope.builtin'.find_files{cwd = vim.fn.systemlist(\"git rev-parse --show-toplevel\")[1]}<CR>" "find file"]
                 :r [":lua require'telescope.builtin'.oldfiles{}<CR>" "recent files"]}
              :b {:name "buffer"
                  :f [":lua require'telescope.builtin'.buffers{}<CR>" "find buffer"]
                  :o [":BufferOrderByBufferNumber<CR>" "order by buffer number"]
                  :p [":bprevious<CR>" "previous buffer"]
                  :n [":bnext<CR>" "next buffer"]
                  :d [":BD<CR>" "delete buffer"]}
              :w {:name "window"
                  :h ["<C-W>h" "move left"]
                  :j ["<C-W>j" "move down"]
                  :k ["<C-W>k" "move up"]
                  :l ["<C-W>l" "move right"]
                  :q ["<C-W>q" "close window"] ;; window https://www.xsprogram.com/content/vim-close-window-without-closing-buffer.html
                  :- [":split<CR><C-w>j<ESC>" "split horizontal"]
                  :/ [":vsplit<CR><C-w>l<ESC>" "split vertical"]
                  := ["<C-w>=" "equalize window sizes"]}
              :t {:name "terminal"
                  :t [":call v:lua.g.toggle_terminal()<CR>" "toggle terminal"]
                  :a [":call v:lua.g.new_terminal()<CR>" "new terminal"]
                  :p [":call v:lua.g.previous_terminal()<CR>" "previous terminal"]
                  :n [":call v:lua.g.next_terminal()<CR>" "next terminal"]}
              :g {:name "git"
                  :s [":LazyGit<CR>" "status"]}
              :p {:name "project"
                  :t [":NvimTreeFindFileToggle<CR>" "toggle tree"]
                  :f [":lua require'telescope.builtin'.git_files{}<CR>" "find file"]
                  :r [":Telescope projects<CR>" "recent project files"]}
              :m {:name "misc"
                  :a {:name "ALE" :f [":ALEFix<CR>" "auto fix"]}
                  :f [":Neoformat<CR>" "format"]
                  :r [":lua require'renamer'.rename{}<CR>" "rename"]}
              :x {:name "trouble"
                  :x [":TroubleToggle<CR>" "toggle"]
                  :w [":TroubleToggle workspace_diagnostics<CR>" "workspace"]
                  :d [":TroubleToggle document_diagnostics<CR>" "document"]
                  :q [":TroubleToggle quickfix<CR>" "quickfix"]
                  :l [":TroubleToggle loclist<CR>" "loclist"]}
              "." {:name "packer"
                   :s [":luafile $MYVIMRC<CR>:PackerSync<CR>" "sync"]}
              "s" {:name "text"
                   :s [":lua require'telescope.builtin'.grep_string{cwd = vim.fn.systemlist(\"git rev-parse --show-toplevel\")[1]}<CR>" "search"]}

              "/" [":lua require'telescope.builtin'.live_grep{ find_command={ 'rg','--hidden','--files','--glob=!.git' }, cwd=vim.fn.systemlist(\"git rev-parse --show-toplevel\")[1]}<CR>" "search"]
              "<leader>" [":lua require('legendary').find('commands')<CR>" "commands"]
              } {:prefix "<leader>"})

(wk.register {:gd [":lua vim.lsp.buf.definition()<CR>" "goto definition"] 
              :gr [":lua require'telescope.builtin'.lsp_references{}<CR>" "list references"]
              :gR [":TroubleToggle lsp_references<CR>" "troubleToggle references"]
              :gt [":lua require'telescope.builtin'.lsp_type_definitions{}<CR>" "list type definitions"]
              :gi [":lua require'telescope.builtin'.lsp_implementations{}<CR>" "list implementations"]
              :ga [":lua require'telescope.builtin'.lsp_document_symbols{}<CR>" "list document symbols"]

              :ge [":ALEDetail<CR>" "detail err"]
              "]q" [":ALENext<CR>" "next err"]
              "[q" [":ALEPrevious<CR>" "previous err"]
              
              :co [":GitConflictChooseOurs<CR>" "conflict choose ours"]
              :ct [":GitConflictChooseTheirs<CR>" "conflict choose theirs"]
              :cb [":GitConflictChooseBoth<CR>" "conflict choose both"]
              :c0 [":GitConflictChooseNone<CR>" "conflict choose none"]
              "]x" [":GitConflictNextConflict<CR>" "next conflict"]
              "[x" [":GitConflictPrevConflict<CR>" "previous conflict"]})

;; Buffer ;;
;;;;;;;;;;;;
;; https://github.com/romgrk/barbar.nvim
(defmap [n] :<leader><Tab> "<C-^>" {:silent true})
(defmap [n] :<leader>0 ":NvimTreeFindFile<CR>" {:silent true})
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

;; BUFFER ;;
;;;;;;;;;;;;
(defmap [n] :<leader>1 ":BufferLineGoToBuffer 1<CR>" {:silent true})
(defmap [n] :<leader>2 ":BufferLineGoToBuffer 2<CR>" {:silent true})
(defmap [n] :<leader>3 ":BufferLineGoToBuffer 3<CR>" {:silent true})
(defmap [n] :<leader>4 ":BufferLineGoToBuffer 4<CR>" {:silent true})
(defmap [n] :<leader>5 ":BufferLineGoToBuffer 5<CR>" {:silent true})
(defmap [n] :<leader>6 ":BufferLineGoToBuffer 6<CR>" {:silent true})
(defmap [n] :<leader>7 ":BufferLineGoToBuffer 7<CR>" {:silent true})
(defmap [n] :<leader>8 ":BufferLineGoToBuffer 8<CR>" {:silent true})
(defmap [n] :<leader>9 ":BufferLineGoToBuffer 9<CR>" {:silent true})
