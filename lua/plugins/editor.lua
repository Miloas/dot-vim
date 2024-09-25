return {
  -- file explorer
  {
    "kyazdani42/nvim-tree.lua",
    tag = 'v1.6.1',
    keys = {
      { "<leader>pt", ":NvimTreeFindFileToggle<CR>", desc = "toggle filetree" },
      { "<leader>0", ":NvimTreeFindFile<CR>" },
    },
    config = function()
      require("nvim-tree").setup({
        hijack_cursor = true,
        update_focused_file = {
          enable = true,
        },
        filters = {
          custom = { ".git$" },
        },
        git = {
          -- disable git integration because it's slow
          enable = false,
          ignore = false,
          show_on_dirs = true,
          timeout = 400,
        },
      })
    end,
  },

  -- -- auto save
  -- {
  --   '0x00-ketsu/autosave.nvim',
  --   -- lazy-loading on events
  --   event = { "InsertLeave", "TextChanged" },
  --   config = function()
  --     require('autosave').setup {
  --       prompt_style = 'notify',
  --     }
  --   end
  -- },

  -- search/replace in multiple files
  {
    'MagicDuck/grug-far.nvim',
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("grug-far").open({ transient = true }) end, desc = "Replace in files (grug-far)" },
    },
    config = function()
      require('grug-far').setup({
        -- options, see Configuration section below
        -- there are no required options atm
        -- engine = 'ripgrep' is default, but 'astgrep' can be specified
      });
    end
  },

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.setup({
        pickers = {
          find_files = {
            find_command = {
              "rg",
              "--files",
              "--color=never",
              "--line-number",
              "--column",
              "--smart-case",
              "--hidden",
              "--glob",
              "!{**/.git/*,**/node_modules/*}",
            },
          },
        },
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob",
            "!{**/.git/*,**/node_modules/*,**/package-lock.json,**/yarn.lock,**/pnpm-lock.yaml,**/lazy-lock.json}",
          },
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
              -- ALT + Q
              ["œ"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-d>"] = actions.delete_buffer,
            },
          },
        },
      })
    end,
    keys = {
      { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "switch buffer" },
      {
        "<leader>/",
        ":lua require'telescope.builtin'.live_grep{layout_strategy='vertical', cwd=vim.fn.systemlist(\"git rev-parse --show-toplevel\")[1]}<CR>",
        desc = "find in files (Grep)",
      },
      -- find
      {
        "<leader>ff",
        ":lua require'telescope.builtin'.find_files{cwd = vim.fn.systemlist(\"git rev-parse --show-toplevel\")[1]}<CR>",
        desc = "find files (root)",
      },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
  },

  -- which-key
  {
    "Cassin01/wf.nvim",
    config = function()
      require("wf").setup()
      local which_key = require("wf.builtin.which_key")

      if _G.__key_prefixes == nil then
        _G.__key_prefixes = {
          n = {},
        }
      end

      _G.__key_prefixes["n"]["<leader>b"] = "+buffer"
      _G.__key_prefixes["n"]["<leader>f"] = "+find"
      _G.__key_prefixes["n"]["<leader>g"] = "+git"
      _G.__key_prefixes["n"]["<leader>h"] = "+gitsigns"
      _G.__key_prefixes["n"]["<leader>s"] = "+text"
      _G.__key_prefixes["n"]["<leader>u"] = "+ui"
      _G.__key_prefixes["n"]["<leader>w"] = "+window"
      _G.__key_prefixes["n"]["<leader>m"] = "+module"
      _G.__key_prefixes["n"]["<leader>x"] = "+diagnostics/quickfix"

      vim.keymap.set(
        "n",
        "<leader>",
        which_key({ text_insert_in_advance = "<Space>", key_group_dict = _G.__key_prefixes["n"] })
      )
    end,
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        -- https://www.compart.com/en/unicode/block/U+2500
        untracked = { text = "┃" },
        change = { text = "┃" },
        changedelete = { text = "┃" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
  },
}
