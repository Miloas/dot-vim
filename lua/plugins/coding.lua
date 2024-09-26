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

  -- Operators motions to quickly replace and exchange text
  {
    "gbprod/substitute.nvim",
    config = true,
    keys = {
      {
        "s",
        function()
          require("substitute.range").operator()
        end,
        desc = "Substitute operator",
      },
      {
        "ss",
        function()
          require("substitute.range").word()
        end,
        desc = "Substitute line",
      },
      {
        "s",
        function()
          require("substitute.range").visual()
        end,
        mode = "x",
        desc = "Substitute visual",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        json = { "biome" },
        javascript = { "biome" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        javascriptreact = { "biome" },
        swift = { "swift_format" },
        go = { "gofmt" },
        rust = { "rustfmt" },
        zig = { "zigfmt" },
      },
      -- Set up format-on-save
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
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
            ellipsis_char = "...",
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
    end,
  },

  -- auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },

  -- more textobjects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
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
    end,
  },

  -- entire buffer textobjects
  {
    "kana/vim-textobj-entire",
    keys = {
      { "ie", mode = { "o", "x" }, desc = "Select entire buffer (file)" },
      { "ae", mode = { "o", "x" }, desc = "Select entire buffer (file)" },
    },
    dependencies = { "kana/vim-textobj-user" },
  }, -- vie, vae to select entire buffer (file)

  -- surround
  {
    "kylechui/nvim-surround",
    config = function(_, opts)
      require("nvim-surround").setup(opts)
    end,
  },

  -- tm indent
  {
    "yioneko/vim-tmindent",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("tmindent").setup({
        enabled = function()
          return vim.tbl_contains({ "lua" }, vim.bo.filetype)
        end,
        use_treesitter = function()
          return true
        end, -- used to detect different langauge region and comments
        default_rule = {},
        rules = {
          lua = {
            comment = { "--" },
            -- inherit pair rules
            inherit = { "&{}", "&()" },
            -- these patterns are the same as TextMate's
            increase = { "\v<%(else|function|then|do|repeat)>((<%(end|until)>)@!.)*$" },
            decrease = { "^\v<%(elseif|else|end|until)>" },
            unindented = {},
            indentnext = {},
          },
        },
      })
    end,
  },

  -- indent object
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      symbol = "╎",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "nvim-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- comments
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
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
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<C-e>",
          },
        },
      })
    end,
  },

  -- multi cursor
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
        local mc = require("multicursor-nvim")

        mc.setup()

        -- Add cursors above/below the main cursor.
        vim.keymap.set({"n", "v"}, "<up>", function() mc.addCursor("k") end)
        vim.keymap.set({"n", "v"}, "<down>", function() mc.addCursor("j") end)

        -- Add a cursor and jump to the next word under cursor.
        vim.keymap.set({"n", "v"}, "<c-n>", function() mc.addCursor("*") end)

        -- Jump to the next word under cursor but do not add a cursor.
        vim.keymap.set({"n", "v"}, "<c-s>", function() mc.skipCursor("*") end)

        -- Rotate the main cursor.
        vim.keymap.set({"n", "v"}, "<left>", mc.nextCursor)
        vim.keymap.set({"n", "v"}, "<right>", mc.prevCursor)

        -- Delete the main cursor.
        -- vim.keymap.set({"n", "v"}, "<leader>x", mc.deleteCursor)

        -- Add and remove cursors with control + left click.
        vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)

        -- vim.keymap.set({"n", "v"}, "<c-q>", function()
        --     if mc.cursorsEnabled() then
        --         -- Stop other cursors from moving.
        --         -- This allows you to reposition the main cursor.
        --         mc.disableCursors()
        --     else
        --         mc.addCursor()
        --     end
        -- end)

        vim.keymap.set("n", "<esc>", function()
            if not mc.cursorsEnabled() then
                mc.enableCursors()
            elseif mc.hasCursors() then
                mc.clearCursors()
            else
                -- Default <esc> handler.
            end
        end)

        -- Align cursor columns.
        -- vim.keymap.set("n", "<leader>a", mc.alignCursors) 

        -- Split visual selections by regex.
        -- vim.keymap.set("v", "S", mc.splitCursors)

        -- Append/insert for each line of visual selections.
        -- vim.keymap.set("v", "I", mc.insertVisual)
        -- vim.keymap.set("v", "A", mc.appendVisual)

        -- match new cursors within visual selections by regex.
        -- vim.keymap.set("v", "M", mc.matchCursors)

        -- Rotate visual selection contents.
        -- vim.keymap.set("v", "<leader>t", function() mc.transposeCursors(1) end)
        -- vim.keymap.set("v", "<leader>T", function() mc.transposeCursors(-1) end)

        -- Customize how cursors look.
        vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
        vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
        vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
        vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    end,
  }
}
