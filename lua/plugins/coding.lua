return {
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

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind-nvim",
    },
    opts = function()
      local cmp = require("cmp")
      local ls = require("luasnip")
      local lspkind = require("lspkind")

      local function tab_func(fallback)
        if cmp.visible() then
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
            preset = 'codicons',
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
  -- better text-objects
  {
    "echasnovski/mini.ai",
    -- keys = {
    --   { "a", mode = { "x", "o" } },
    --   { "i", mode = { "x", "o" } },
    -- },
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
      ---@type table<string, string|table>
      local i = {
        [" "] = "Whitespace",
        ['"'] = 'Balanced "',
        ["'"] = "Balanced '",
        ["`"] = "Balanced `",
        ["("] = "Balanced (",
        [")"] = "Balanced ) including white-space",
        [">"] = "Balanced > including white-space",
        ["<lt>"] = "Balanced <",
        ["]"] = "Balanced ] including white-space",
        ["["] = "Balanced [",
        ["}"] = "Balanced } including white-space",
        ["{"] = "Balanced {",
        ["?"] = "User Prompt",
        _ = "Underscore",
        a = "Argument",
        b = "Balanced ), ], }",
        c = "Class",
        f = "Function",
        o = "Block, conditional, loop",
        q = "Quote `, \", '",
        t = "Tag",
      }
      local a = vim.deepcopy(i)
      for k, v in pairs(a) do
        a[k] = v:gsub(" including.*", "")
      end

      local ic = vim.deepcopy(i)
      local ac = vim.deepcopy(a)
      for key, name in pairs({ n = "Next", l = "Last" }) do
        i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
        a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
      end
      require("which-key").register({
        mode = { "o", "x" },
        i = i,
        a = a,
      })
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
