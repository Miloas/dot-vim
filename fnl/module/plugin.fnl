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
  :mhinz/vim-startify {}
  :weilbith/nvim-code-action-menu {}
  :p00f/nvim-ts-rainbow {}
  :onsails/lspkind-nvim {}
  :folke/lsp-colors.nvim {}
  :ellisonleao/gruvbox.nvim {}
  :kyazdani42/nvim-web-devicons {}
  :romgrk/barbar.nvim {}
  :nvim-lualine/lualine.nvim {:mod :lualine :requires [[:kyazdani42/nvim-web-devicons]]}

  ;; General Settings
  :vim-test/vim-test {}
  :karb94/neoscroll.nvim {:mod :neoscroll}
  :folke/trouble.nvim {:mod :trouble}
  :RRethy/vim-illuminate {}
  :tpope/vim-abolish {}
  :HerringtonDarkholme/yats.vim {}
  :lewis6991/impatient.nvim {}
  :PeterRincker/vim-argumentative {}
  :hashivim/vim-terraform {}
  :tpope/vim-sleuth {}     
  :tpope/vim-obsession {}  
  :qpkorr/vim-bufkill {}   
  :voldikss/vim-floaterm {}
  :yuttie/comfortable-motion.vim {}
  :windwp/nvim-autopairs {:mod :autopairs :requires [[:hrsh7th/nvim-cmp]]}
  :nvim-treesitter/nvim-treesitter {:run ":TSUpdate" :mod :treesitter}

  ;; File Management
  :kyazdani42/nvim-tree.lua {:mod :nvim-tree :branch :master}
  :nvim-telescope/telescope-file-browser.nvim {}
  :filipdutescu/renamer.nvim {:branch :master :mod :renamer}

  ;; LSP
  :w0rp/ale {:mod :ale}
  :neoclide/coc.nvim {:branch :release}

  ;; Completion
  :nvim-lua/popup.nvim {}
  :nvim-lua/plenary.nvim {}
  :nvim-telescope/telescope.nvim {:mod :telescope}
  :nvim-telescope/telescope-fzf-native.nvim {:run "make"}
  :Olical/conjure {}
  :github/copilot.vim {:mod :copilot}

  ;; Debugging 
  :mfussenegger/nvim-dap {}
  :rcarriga/nvim-dap-ui {}

  ;; Git
  :kdheepak/lazygit.nvim {}
  :lewis6991/gitsigns.nvim {:mod :gitsigns}

  ;; Key Bindings
  :tpope/vim-commentary {}
  :tpope/vim-surround {}

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
)
