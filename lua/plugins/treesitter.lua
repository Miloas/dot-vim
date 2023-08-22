return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "andymass/vim-matchup"
    },
    keys = {
      { "<leader>v", desc = "Increment selection" },
      { "<bs>", desc = "Schrink selection", mode = "x" },
    },
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      matchup = { enable = true },
      indent = { enable = true },
      rainbow = { enable = true, extended_mode = true },
      context_commentstring = { enable = true, enable_autocmd = false },
      ensure_installed = {
        "c",
        "go",
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "tsx",
        "typescript",
        "yaml",
        "zig",
        "rust",
        "svelte",
        "swift"
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<leader>v",
          node_incremental = "<leader>v",
          scope_incremental = "<nop>",
          node_decremental = "<bs>",
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
		"RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("illuminate").configure({
        delay = 200
      })
		end,
	},
}
