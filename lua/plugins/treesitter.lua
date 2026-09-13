local ensure_installed = {
  "bash",
  "c",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "rust",
  "swift",
  "tsx",
  "typescript",
  "yaml",
  "zig",
}

-- nvim-treesitter's `main` branch dropped the incremental selection module, so
-- keep a minimal stand-in for the `<leader>v` / `<bs>` workflow.
local incremental = {}
do
  local history = {}

  local function visual_range()
    local anchor = vim.fn.getpos("v")
    local cursor = vim.fn.getpos(".")
    local srow, scol = anchor[2] - 1, anchor[3] - 1
    local erow, ecol = cursor[2] - 1, cursor[3] - 1
    if srow > erow or (srow == erow and scol > ecol) then
      srow, scol, erow, ecol = erow, ecol, srow, scol
    end
    return srow, scol, erow, ecol + 1
  end

  local function in_visual()
    return vim.fn.mode():find("^[vV\22]") ~= nil
  end

  local function select_range(srow, scol, erow, ecol)
    -- treesitter end columns are exclusive, visual mode's are inclusive
    if ecol == 0 then
      erow = erow - 1
      ecol = #(vim.api.nvim_buf_get_lines(0, erow, erow + 1, false)[1] or "")
    end
    if in_visual() then
      vim.cmd("normal! \27")
    end
    vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
    vim.cmd("normal! v")
    vim.api.nvim_win_set_cursor(0, { erow + 1, math.max(ecol - 1, 0) })
  end

  local function contains(node, srow, scol, erow, ecol)
    local nsr, nsc, ner, nec = node:range()
    local starts_before = nsr < srow or (nsr == srow and nsc <= scol)
    local ends_after = ner > erow or (ner == erow and nec >= ecol)
    return starts_before and ends_after
  end

  local function same(node, srow, scol, erow, ecol)
    local nsr, nsc, ner, nec = node:range()
    return nsr == srow and nsc == scol and ner == erow and nec == ecol
  end

  function incremental.increment()
    local buf = vim.api.nvim_get_current_buf()
    local srow, scol, erow, ecol

    if in_visual() then
      srow, scol, erow, ecol = visual_range()
    else
      history[buf] = {}
      local cursor = vim.api.nvim_win_get_cursor(0)
      srow, scol = cursor[1] - 1, cursor[2]
      erow, ecol = srow, scol + 1
    end

    local ok, node = pcall(vim.treesitter.get_node, { bufnr = buf, pos = { srow, scol } })
    if not ok or not node then
      return
    end
    while node and (not contains(node, srow, scol, erow, ecol) or same(node, srow, scol, erow, ecol)) do
      node = node:parent()
    end
    if not node then
      return
    end

    history[buf] = history[buf] or {}
    table.insert(history[buf], { srow, scol, erow, ecol })
    select_range(node:range())
  end

  function incremental.decrement()
    local buf = vim.api.nvim_get_current_buf()
    local previous = history[buf] and table.remove(history[buf])
    if previous then
      select_range(unpack(previous))
    end
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- the `master` branch is frozen and unsupported on nvim 0.12+
    lazy = false, -- the rewrite does not support lazy-loading
    build = ":TSUpdate",
    keys = {
      { "<leader>v", incremental.increment, mode = { "n", "x" }, desc = "Increment selection" },
      { "<bs>", incremental.decrement, mode = "x", desc = "Shrink selection" },
    },
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install(ensure_installed)

      -- Highlighting is provided by Neovim itself now; turn it on for any
      -- filetype that has a parser available.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if lang and pcall(vim.treesitter.language.add, lang) then
            pcall(vim.treesitter.start, args.buf, lang)
          end
        end,
      })
    end,
  },

  -- textobject queries consumed by mini.ai
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = true,
  },

  -- matchup ships its own treesitter integration now, no module registration needed
  {
    "andymass/vim-matchup",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      treesitter = {
        stopline = 500,
      },
    },
  },

  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure({
        delay = 200,
      })
    end,
  },
}
