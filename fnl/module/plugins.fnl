(module module.plugins
  {require {paq paq}})

(def- paq paq.paq)

;; Appearance
(paq "folke/lsp-colors.nvim")
(paq "vim-airline/vim-airline")
(paq "vim-airline/vim-airline-themes")
(paq "morhetz/gruvbox")
;; (paq "ryanoasis/vim-devicons")
(paq "kyazdani42/nvim-web-devicons")
(paq "romgrk/barbar.nvim")

;; General Settings
(paq "tpope/vim-sleuth")
;; (paq "tpope/vim-endwise")
(paq "tpope/vim-obsession")
(paq "qpkorr/vim-bufkill")
(paq "voldikss/vim-floaterm")
(paq "yuttie/comfortable-motion.vim")
(paq "nvim-treesitter/nvim-treesitter")
(paq "windwp/nvim-autopairs")

;; File Management
(paq "ms-jpq/chadtree" :branch "chad" :do "python3 -m chadtree deps")
(paq "nvim-telescope/telescope-file-browser.nvim")
(paq "filipdutescu/renamer.nvim" :branch "master")

;; LSP
(paq "neovim/nvim-lspconfig")
(paq "nvim-lua/plenary.nvim")

;; Completion
(paq "nvim-lua/popup.nvim")
(paq "nvim-lua/plenary.nvim")
(paq "nvim-telescope/telescope.nvim")
(paq "Olical/conjure")
(paq "ms-jpq/coq_nvim")
(paq "github/copilot.vim")

;; Debugging 
(paq "mfussenegger/nvim-dap")
(paq "rcarriga/nvim-dap-ui")

;; Git
(paq "airblade/vim-gitgutter")
(paq "kdheepak/lazygit.nvim")

;; Key Bindings
(paq "tpope/vim-commentary")
(paq "tpope/vim-surround")
(paq "folke/which-key.nvim")

;; Project
(paq "ahmedkhalf/project.nvim")

;; Motion
(paq "gbprod/substitute.nvim")
(paq "phaazon/hop.nvim")

;; Text object
(paq "michaeljsmith/vim-indent-object")
