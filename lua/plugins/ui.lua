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
    version = "*",
    dependencies = { "catppuccin/nvim" },
    -- `opts` must be a function: the highlights are read from catppuccin, which
    -- is only guaranteed to be loaded by the time the spec is resolved.
    opts = function()
      return {
        -- moved from `catppuccin.groups.integrations.bufferline`; `get_theme()`
        -- now returns a function that bufferline calls itself.
        highlights = require("catppuccin.special.bufferline").get_theme(),
        options = {
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
            },
          },
        },
      }
    end,
  },

  -- lsp symbol navigation
  {
    'Bekaboo/dropbar.nvim',
    event = { "BufReadPost", "BufNewFile" },
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim'
    },
    config = function()
      require("dropbar").setup({
        icons = {
          ui = {
            bar = {
              separator = "  ",
            }
          }
        }
      })
    end,
  },

  -- status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        options = {
          icons_enabled = true,
          theme = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              icon = "",
              separator = { left = "", right = "" },
              color = {
                fg = "#1c1d21",
                bg = "#b4befe",
              },
            },
          },
          lualine_b = {
            {
              "branch",
              icon = "",
              separator = { left = "", right = "" },
              color = {
                fg = "#1c1d21",
                bg = "#7d83ac",
              },
            },
            {
              "diff",
              separator = { left = "", right = "" },
              color = {
                fg = "#1c1d21",
                bg = "#7d83ac",
              },
            },
          },
          lualine_c = {
            {
              "diagnostics",
              separator = { left = "", right = "" },
              color = {
                bg = "#45475a",
              },
            },
            {
              "filename",
            },
          },
          lualine_x = { "filesize" },
          lualine_y = {
            {
              "filetype",
              icons_enabled = false,
              color = {
                fg = "#1C1D21",
                bg = "#eba0ac",
              },
            },
          },
          lualine_z = {
            {
              "location",
              icon = "",
              color = {
                fg = "#1c1d21",
                bg = "#f2cdcd",
              },
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { "nvim-tree", "lazy" },
      }
    end,
  },

  -- notification
  {
    'j-hui/fidget.nvim',
    event = 'VeryLazy',
    opts = {
      notification = {
        override_vim_notify = true
      }
    }
  },

  -- icons
  {
    'echasnovski/mini.icons',
    version = false,
    lazy = true,
    opts = {},
    init = function()
      -- let plugins that ask for nvim-web-devicons get mini.icons instead
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },


  -- line decorations (color)
  {
    "mvllow/modes.nvim",
    event = "VeryLazy",
    opts = {},
  },

  "mhinz/vim-startify",
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      auto_resize_height = true,
    },
    config = function(_, opts)
      require("bqf").setup(opts)
    end,
  }
}
