local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

return {

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
          },
        },
      },
    },
  },

  -- status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    sections = {
      lualine_b = { {'diff', source = diff_source}, },
    },
    opts = {
      theme = "tokyonight",
      globastatus = true
    }
  },

  -- lsp symbol navigation
  {
    "utilyre/barbecue.nvim",
    dependencies = {
      "SmiteshP/nvim-navic"
    },
    config = function(_, opts)
      require("barbecue").setup(opts)
    end,
  },

  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },


  -- line decorations (color)
  {
    "mvllow/modes.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function(_, opts)
      require("modes").setup(opts)
    end,
  },

  "mhinz/vim-startify",
  {
    "kevinhwang91/nvim-bqf",
    opts = {
      auto_enable = true,
      auto_resize_height = true,
    },
    config = function(_, opts)
      require("bqf").setup(opts)
    end,
  }
}
