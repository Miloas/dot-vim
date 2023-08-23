-- Prettier function for formatter
local prettier = function()
  return {
    exe = "prettier",
    args = {
      "--config-precedence",
      "prefer-file",
      -- you can add more global setup here
      "--stdin-filepath",
      vim.fn.shellescape(vim.api.nvim_buf_get_name(0)),
    },
    stdin = true,
    try_node_modules = true,
  }
end

return {
  "prisma/vim-prisma",
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "Miloas/miloas.snippets",
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      { mode = { "i", "s" }, "<C-l>", function()
          local ls = require("luasnip")
          if ls.choice_active() then ls.change_choice(1) end
        end,
      },
      { mode = { "i", "s" }, "<C-h>", function()
          local ls = require("luasnip")
          if ls.choice_active() then ls.change_choice(-1) end
        end,
      },
    },
    config = function()
      local ls = require("luasnip")
      local ft_func = require("luasnip.extras.filetype_functions")
      ls.config.set_config({
        updateevents = "TextChanged,TextChangedI",
        ft_func = ft_func.from_pos_or_filetype,
      })
      ls.add_snippets("go", require("snippets").go)
    end,
  },

  -- format
  {
    "mhartington/formatter.nvim",
    config = function()
      -- Utilities for creating configurations
      local util = require "formatter.util"

      -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
      require("formatter").setup {
        -- Enable or disable logging
        logging = true,
        -- Set the log level
        log_level = vim.log.levels.WARN,
        -- All formatter configurations are opt-in
        filetype = {
          typescriptreact = { prettier },
          javascriptreact = { prettier },
          javascript = { prettier },
          typescript = { prettier },
          json = { prettier },
          jsonc = { prettier },
          html = { prettier },
          css = { prettier },
          scss = { prettier },
          graphql = { prettier },
          markdown = { prettier },
          vue = { prettier },
          astro = { prettier },
          yaml = { prettier },
          -- Formatter configurations for filetype "lua" go here
          -- and will be executed in order
          lua = {
            -- "formatter.filetypes.lua" defines default configurations for the
            -- "lua" filetype
            require("formatter.filetypes.lua").stylua,

            -- You can also define your own configuration
            function()
              -- Supports conditional formatting
              if util.get_current_buffer_file_name() == "special.lua" then
                return nil
              end

              -- Full specification of configurations is down below and in Vim help
              -- files
              return {
                exe = "stylua",
                args = {
                  "--search-parent-directories",
                  "--stdin-filepath",
                  util.escape_path(util.get_current_buffer_file_path()),
                  "--",
                  "-",
                },
                stdin = true,
              }
            end
          },
          swift = {
            function()
              return {
                exe = "swiftformat",
                args = {
                  "--stdinpath",
                  util.escape_path(util.get_current_buffer_file_path()),
                },
                stdin = true,
              }
            end
          },

          -- Use the special "*" filetype for defining formatter configurations on
          -- any filetype
          ["*"] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require("formatter.filetypes.any").remove_trailing_whitespace
          }
        }
      }
    end
  },

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    opts = function()
      local cmp = require("cmp")
      local ls = require("luasnip")
      local lspkind = require("lspkind")

      local function tab_func(fallback)
        if cmp.visible() then
          local entry = cmp.get_selected_entry()
          if not entry then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          end
          cmp.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          })
        elseif ls.expand_or_jumpable() then
          ls.expand_or_jump()
        else
          fallback()
        end
      end

      local function s_tab_func(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif ls.jumpable(-1) then
          ls.jump(-1)
        else
          fallback()
        end
      end

      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          documentation = false,
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = '...',
            -- preset = 'codicons',
          }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        mapping = {
          ["<C-K>"] = cmp.mapping.select_prev_item(),
          ["<C-J>"] = cmp.mapping.select_next_item(),
          ["<C-D>"] = cmp.mapping.scroll_docs(-4),
          ["<C-F>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-E>"] = function(fallback)
            cmp.mapping.abort()
            local copilot_keys = vim.fn["copilot#Accept"]()
            if copilot_keys ~= "" then
              vim.api.nvim_feedkeys(copilot_keys, "i", true)
            else
              fallback()
            end
          end,
          ["<Tab>"] = cmp.mapping({
            i = tab_func,
            s = tab_func,
          }),
          ["<S-Tab>"] = cmp.mapping({
            i = s_tab_func,
            s = s_tab_func,
          }),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        },
      }
    end
  },

  -- auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },

  -- surround
  {
    "kylechui/nvim-surround",
    config = function(_, opts)
      require("nvim-surround").setup(opts)
    end
  },

  -- comments
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      hooks = {
        pre = function()
          require("ts_context_commentstring.internal").update_commentstring({})
        end,
      },
    },
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
    end,
  }
}
