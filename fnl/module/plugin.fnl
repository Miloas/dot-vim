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
  :folke/lsp-colors.nvim {}
  :vim-airline/vim-airline {}
  :vim-airline/vim-airline-themes {}
  :morhetz/gruvbox {}
  :kyazdani42/nvim-web-devicons {}
  :romgrk/barbar.nvim {}

  ;; General Settings
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
  :kyazdani42/nvim-tree.lua {:mod :nvim-tree}
  :nvim-telescope/telescope-file-browser.nvim {}
  :filipdutescu/renamer.nvim {:branch :master :mod :renamer}

  ;; LSP
  :neovim/nvim-lspconfig {:mod :lsp :requires [[:hrsh7th/cmp-nvim-lsp]]}
  :nvim-lua/plenary.nvim {}
  :w0rp/ale {:mod :ale}

  ;; Completion
  :nvim-lua/popup.nvim {}
  :nvim-lua/plenary.nvim {}
  :nvim-telescope/telescope.nvim {:mod :telescope}
  :Olical/conjure {}
  :github/copilot.vim {:mod :copilot}
  :hrsh7th/nvim-cmp {:mod :nvim-cmp :requires [[:L3MON4D3/LuaSnip]]}
  :hrsh7th/cmp-nvim-lsp {}
  :saadparwaiz1/cmp_luasnip {}
  :L3MON4D3/LuaSnip {}

  ;; Debugging 
  :mfussenegger/nvim-dap {}
  :rcarriga/nvim-dap-ui {}

  ;; Git
  :airblade/vim-gitgutter {}
  :kdheepak/lazygit.nvim {}

  ;; Key Bindings
  :tpope/vim-commentary {}
  :tpope/vim-surround {}
  :folke/which-key.nvim {}

  ;; Project
  :ahmedkhalf/project.nvim {:mod :project}

  ;; S
  :ggandor/lightspeed.nvim {}


  ;; Text object
  :michaeljsmith/vim-indent-object {}
)