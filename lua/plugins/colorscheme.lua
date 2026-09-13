return {
  -- catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      term_colors = true,
      transparent_background = false,
      styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
      },
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#000000",
          crust = "#000000",
        },
      },
      -- Auto-detection calls `vim.pack.get()`, which creates an empty
      -- `site/pack/core/opt` that both `:checkhealth vim.pack` and lazy then
      -- warn about. Everything it used to detect is listed explicitly below,
      -- so add new plugins here rather than turning this back on.
      auto_integrations = false,
      integrations = {
        illuminate = {
          enabled = true,
          lsp = false,
        },
        -- previously enabled by auto-detection
        dropbar = true,
        fidget = true,
        flash = true,
        grug_far = true,
        nvim_surround = true,
        which_key = true,
        lsp_trouble = false,
        treesitter = true,
        nvimtree = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        cmp = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        mason = false,
        gitsigns = true,
        telescope = {
          enabled = true,
        },
      },
    },
  },
}
