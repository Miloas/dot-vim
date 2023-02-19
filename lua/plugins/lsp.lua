return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "jose-elias-alvarez/typescript.nvim",
    },
    autoformat = true,
    opts = {
      servers = {
        gopls = {},
        rust_analyzer = {},
        sourcekit = {},
        zls = {},
        tsserver = {},
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true) },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
      setup = {
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
      },
    },
    config = function(_, opts)
      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      ---@param on_attach fun(client, buffer)
      local function on_attach(on_attach_f)
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach_f(client, buffer)
          end,
        })
      end

      on_attach(function(_, buffer)
        local function diagnostic_goto(next, severity)
          local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
          severity = severity and vim.diagnostic.severity[severity] or nil
          return function()
            go({ severity = severity })
          end
        end

        vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { buffer = buffer, silent = true, desc = "goto definition" })
        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = buffer, silent = true, desc = "list references" })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buffer, silent = true, desc = "goto declaration" })
        vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<cr>", { buffer = buffer, silent = true, desc = "list implementations" })
        vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", { buffer = buffer, silent = true, desc = "list type definitions" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer, silent = true, desc = "show hover" })
        vim.keymap.set({"n", "v"}, "<C-.>", vim.lsp.buf.code_action, { buffer = buffer, silent = true, desc = "code action" })
        vim.keymap.set("n", "]d", diagnostic_goto(true), { buffer = buffer, silent = true, desc = "next diagnostic" })
        vim.keymap.set("n", "[d", diagnostic_goto(false), { buffer = buffer, silent = true, desc = "previous diagnostic" })
        vim.keymap.set("n", "]e", diagnostic_goto(true, "Error"), { buffer = buffer, silent = true, desc = "next error" })
        vim.keymap.set("n", "[e", diagnostic_goto(false, "Error"), { buffer = buffer, silent = true, desc = "previous error" })
        vim.keymap.set("n", "]w", diagnostic_goto(true, "Warning"), { buffer = buffer, silent = true, desc = "next warning" })
        vim.keymap.set("n", "[w", diagnostic_goto(false, "Warning"), { buffer = buffer, silent = true, desc = "previous warning" })

      end)

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          setup(server)
        end
      end
    end
  },
  {
    "filipdutescu/renamer.nvim",
    version = false,
    event = "VeryLazy",
    keys = {
      {"<leader>mr", '<cmd>lua require("renamer").rename()<cr>', desc = "lsp rename"},
    },
    config = function()
      require("renamer").setup()
    end,
  }
}
