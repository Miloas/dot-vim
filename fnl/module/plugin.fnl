(module module.plugin
  {autoload {nvim aniseed.nvim
             a aniseed.core
             packer packer}})

(defn safe-require-plugin-config [name]
  (let [(ok? val-or-err) (pcall require (.. :module.plugins. name))]
    (when (not ok?)
      (print (.. "dotfiles error: " val-or-err)))))

(defn- use [...]
  "Iterates through the arguments as pairs and calls packer's use function for
  each of them. Works around Fennel not liking mixed associative and sequential
  tables as well."
  (let [pkgs [...]]
    (packer.startup
      (fn [use]
        (for [i 1 (a.count pkgs) 2]
          (let [name (. pkgs i)
                opts (. pkgs (+ i 1))]
            (-?> (. opts :mod) (safe-require-plugin-config))
            (use (a.assoc opts 1 name)))))))
  nil)

;; Plugins to be managed by packer.
(use
  ;; Appearance
  :mvllow/modes.nvim {:mod :modes} ;; line decorations (color)
  :mhinz/vim-startify {} ;; fancy start screen
  :weilbith/nvim-code-action-menu {} ;; code action menu <C-.>
  :mrjones2014/nvim-ts-rainbow {} ;; rainbow parentheses
  :onsails/lspkind-nvim {} ;; vscode-like completion icons
  :folke/lsp-colors.nvim {} ;; error/hint/warning colors
  :miloas/gruvbox.nvim {} ;; theme
  :kyazdani42/nvim-web-devicons {} ;; icons
  :nvim-lualine/lualine.nvim {:mod :lualine :requires [[:kyazdani42/nvim-web-devicons]]} ;; status line
  :akinsho/bufferline.nvim {:mod :bufferline :requires [[:nvim-tree/nvim-web-devicons]]} ;; tab

  ;; General Settings
  :karb94/neoscroll.nvim {:mod :neoscroll} ;; zz,zt,zb
  :folke/trouble.nvim {:mod :trouble} ;; diagnostics <leader>x
  :RRethy/vim-illuminate {} ;; highlight other uses of the word under the cursor
  ;; :Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or}  {despe,sepa}rat{}
  ;; :Subvert/di{e,ce}/spinner{,s}/g
  :tpope/vim-abolish {}
  ; :HerringtonDarkholme/yats.vim {}
  :lewis6991/impatient.nvim {} ;; speed up loading lua modules in neovim to improve startup time
  ; :hashivim/vim-terraform {}
  :tpope/vim-sleuth {}     
  :qpkorr/vim-bufkill {} ;; kill buffers but doesn't close the window
  :voldikss/vim-floaterm {} ;; float window terminal
  ; :yuttie/comfortable-motion.vim {}
  :windwp/nvim-autopairs {:mod :autopairs :requires [[:hrsh7th/nvim-cmp]]}
  :nvim-treesitter/nvim-treesitter {:run ":TSUpdate" :mod :treesitter}
  :nvim-treesitter/nvim-treesitter-textobjects {}
  :mrjones2014/legendary.nvim {:mod :legendary :branch :master} ;; cmd
  :stevearc/dressing.nvim {} ;; improve ui
  :fedepujol/move.nvim {} ;; move line/char/block

  ;; File Management
  :kyazdani42/nvim-tree.lua {:mod :nvim-tree :branch :master}
  :nvim-telescope/telescope-file-browser.nvim {}
  :filipdutescu/renamer.nvim {:branch :master :mod :renamer}

  ;; LSP
  :neovim/nvim-lspconfig {:mod :lsp :requires [[:hrsh7th/cmp-nvim-lsp]]}
  :w0rp/ale {:mod :ale} ;; async lint

  ;; Completion
  ; :nvim-lua/popup.nvim {}
  :nvim-lua/plenary.nvim {} ;; utils for lua script
  :nvim-telescope/telescope.nvim {:mod :telescope}
  :nvim-telescope/telescope-fzf-native.nvim {:run "make"}
  ; :Olical/conjure {} ;; interative environment for evaluating code
  :github/copilot.vim {:mod :copilot}
  :hrsh7th/nvim-cmp {:mod :nvim-cmp :requires [[:L3MON4D3/LuaSnip]]}
  :hrsh7th/cmp-nvim-lsp {}
  :saadparwaiz1/cmp_luasnip {}
  :L3MON4D3/LuaSnip {}

  ;; Debugging 
  :mfussenegger/nvim-dap {}
  :rcarriga/nvim-dap-ui {}

  ;; Git
  :kdheepak/lazygit.nvim {}
  :lewis6991/gitsigns.nvim {:mod :gitsigns}
  :akinsho/git-conflict.nvim {:mod :git-conflict}

  ;; Key Bindings
  :tpope/vim-commentary {}
  :kylechui/nvim-surround {:mod :nvim-surround}

  ;; Project
  :ahmedkhalf/project.nvim {:mod :project}

  ;; S
  :ggandor/lightspeed.nvim {}

  ;; Text object
  :michaeljsmith/vim-indent-object {}

  ;; Formatter
  :sbdchd/neoformat {}
  
  ;; Zen
  :Pocco81/TrueZen.nvim {}

  ;; which-key
  :folke/which-key.nvim {:mod :which-key}
)
