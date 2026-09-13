return {
  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "^1",
    keys = {
      { "<leader>pt", ":NvimTreeFindFileToggle<CR>", desc = "toggle filetree" },
      { "<leader>0", ":NvimTreeFindFile<CR>" },
    },
    opts = {
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
    },
  },

  -- search/replace in multiple files
  {
    "MagicDuck/grug-far.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("grug-far").open({ transient = true }) end, desc = "Replace in files (grug-far)" },
    },
    opts = {},
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
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
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
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        spelling = {
          enabled = true,
        },
      },
      spec = {
        { "<leader>b", group = "+buffer" },
        { "<leader>f", group = "+find" },
        { "<leader>g", group = "+git" },
        { "<leader>h", group = "+gitsigns" },
        { "<leader>s", group = "+text" },
        { "<leader>u", group = "+ui" },
        { "<leader>w", group = "+window" },
        { "<leader>m", group = "+module" },
        { "<leader>x", group = "+diagnostics/quickfix" },
        { "<leader>p", group = "+project" },
        { "g", group = "+goto" },
        { "]", group = "+next" },
        { "[", group = "+prev" },
        mode = { "n", "v" },
      },
    },
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
        local gs = require("gitsigns")

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", function() gs.nav_hunk("next") end, "Next Hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Hunk")
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.stage_hunk, "Unstage Hunk")
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
    version = false,
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    version = "^3",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },

  -- lsp rename
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {
      input_buffer_type = "dressing",
    },
    keys = {
      { "<leader>mr", ":IncRename ", desc = "LSP rename" },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
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
