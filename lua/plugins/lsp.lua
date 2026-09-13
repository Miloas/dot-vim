local function diagnostic_jump(count, severity)
  return function()
    vim.diagnostic.jump({
      count = count,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end

local function mappings(client, buffer)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buffer, silent = true, desc = desc })
  end

  map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", "goto definition")
  map("n", "gr", "<cmd>Telescope lsp_references<cr>", "list references")
  map("n", "gD", vim.lsp.buf.declaration, "goto declaration")
  map("n", "gI", "<cmd>Telescope lsp_implementations<cr>", "list implementations")
  map("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", "list type definitions")
  map("n", "K", vim.lsp.buf.hover, "show hover")
  map({ "n", "v" }, "<C-.>", vim.lsp.buf.code_action, "code action")
  map("n", "]d", diagnostic_jump(1), "next diagnostic")
  map("n", "[d", diagnostic_jump(-1), "previous diagnostic")
  map("n", "]e", diagnostic_jump(1, "ERROR"), "next error")
  map("n", "[e", diagnostic_jump(-1, "ERROR"), "previous error")
  map("n", "]w", diagnostic_jump(1, "WARN"), "next warning")
  map("n", "[w", diagnostic_jump(-1, "WARN"), "previous warning")
end

return {
  {
    "neovim/nvim-lspconfig",
    -- not lazy: `vim.lsp.enable()` hooks FileType, which has already fired for
    -- the buffer nvim was started with by the time a BufReadPre trigger runs.
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      },
      -- Each entry is merged into the config that nvim-lspconfig ships in `lsp/`
      -- and then enabled with `vim.lsp.enable()`. See `:h lsp-config`.
      servers = {
        -- relay-compiler's LSP was dropped from nvim-lspconfig, so define it here.
        relay_lsp = {
          cmd = { "relay-compiler", "lsp" },
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          -- Never call `on_dir` unless a relay config is actually present.
          -- Using `root_markers` isn't enough: with no match the server would
          -- still start in single-file mode and fail in every JS project.
          root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, function(name)
              return name:match("^relay%.config%.[cm]?jsx?$") or name == "relay.config.json"
            end)
            if root then
              on_dir(root)
            end
          end,
        },
        gopls = {
          settings = {
            gopls = {
              semanticTokens = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        quick_lint_js = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
        },
        tailwindcss = {
          -- nvim-lspconfig copies tailwindcss-intellisense's VSCode filetype
          -- list, which includes names Nvim never sets (`django-html`, `erb`,
          -- `hbs`, `html-eex`, `ejs`, `mdx`, ...). Nvim's equivalents for those
          -- are already below, so the rest are dead entries that only show up
          -- as `:checkhealth vim.lsp` warnings. Add a filetype here if you
          -- teach Nvim to detect a new one.
          filetypes = {
            -- html / templates
            "astro",
            "blade",
            "clojure",
            "eelixir",
            "elixir",
            "eruby",
            "haml",
            "handlebars",
            "heex",
            "html",
            "htmlangular",
            "htmldjango",
            "liquid",
            "markdown",
            "mustache",
            "php",
            "razor",
            "templ",
            "twig",
            -- css
            "css",
            "less",
            "sass",
            "scss",
            "stylus",
            -- js / ts
            "javascript",
            "javascriptreact",
            "rescript",
            "svelte",
            "typescript",
            "typescriptreact",
            "vue",
          },
        },
        sourcekit = {},
        zls = {},
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectory = { mode = "auto" },
          },
        },
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              -- `workspace.library` used to be set from
              -- `nvim_get_runtime_file("", true)`, but that was evaluated while
              -- the spec was being read, so it only ever captured ~17 paths and
              -- missed every lazy-loaded plugin. lazydev.nvim resolves the
              -- library on demand instead.
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.diagnostic.config(opts.diagnostics)

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      -- https://github.com/matsui54/dotfiles/blob/master/nvim/lua/lsp_rc.lua#L64
      capabilities.textDocument.completion.completionItem.labelDetailsSupport = false

      -- Applies to every server, including ones enabled by mason-lspconfig.
      vim.lsp.config("*", { capabilities = capabilities })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = args.data and args.data.client_id and vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end
          local buffer = args.buf

          if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
              range = true,
            }
          end

          -- quick-lint-js is fast enough to lint while typing
          if client.name == "quick_lint_js" then
            vim.diagnostic.config({ update_in_insert = true }, vim.lsp.diagnostic.get_namespace(client.id))
          end

          -- `LspEslintFixAll` is created by nvim-lspconfig's own eslint on_attach
          if client.name == "eslint" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = buffer,
              command = "LspEslintFixAll",
            })
          end

          mappings(client, buffer)
        end,
      })

      for server, server_opts in pairs(opts.servers) do
        if server_opts then
          vim.lsp.config(server, server_opts == true and {} or server_opts)
          vim.lsp.enable(server)
        end
      end
    end,
  },
  {
    -- RUST LSP
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false, -- this plugin is already lazy
    init = function()
      vim.g.rustaceanvim = {
        -- LSP configuration
        --
        -- REFERENCE:
        -- https://rust-analyzer.github.io/book/configuration.html
        --
        -- NOTE: The configuration format is `rust-analyzer.<section>.<property>`.
        --       <section> should be an object.
        --       <property> should be a primitive.
        server = {
          on_attach = function(client, bufnr)
            -- vim-illuminate attaches itself on LspAttach; calling its legacy
            -- on_attach here just triggers deprecation warnings.
            mappings(client, bufnr)
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
              assist = {
                importEnforceGranularity = true,
                importPrefix = "crate",
              },
              cargo = { allFeatures = true },
              checkOnSave = true,
              check = {
                -- default: `cargo check`
                command = "clippy",
                allFeatures = true,
              },
              inlayHints = {
                lifetimeElisionHints = {
                  enable = true,
                  useParameterNames = true,
                },
              },
            },
          },
        },
      }
    end,
  },
  {
    "mason-org/mason.nvim",
    version = "^2",
    -- must not be lazy: setup() is what prepends mason's bin dir to $PATH, and
    -- the servers below are resolved from there.
    lazy = false,
    priority = 100,
    opts = {},
    init = function()
      -- `:checkhealth mason` probes every package-manager runtime it *could*
      -- use and warns for each missing one, with no option to scope it to what
      -- you actually install (mason-org/mason.nvim#1744). None of the installed
      -- packages need these, so drop exactly those lines and nothing else.
      --
      -- This has to run before `mason.health` is first required: that module
      -- binds `vim.health.warn` at load time, so patching it later is too late.
      local ignored = {
        ["luarocks: not available"] = true,
        ["Composer: not available"] = true,
        ["PHP: not available"] = true,
        ["java: not available"] = true,
        ["javac: not available"] = true,
        ["julia: not available"] = true,
      }
      local warn = vim.health.warn
      vim.health.warn = function(msg, ...)
        if type(msg) == "string" and ignored[msg] then
          return
        end
        return warn(msg, ...)
      end
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    version = "^2",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "tailwindcss",
        "eslint",
        "quick_lint_js",
        "lua_ls",
      },
      -- typescript-tools.nvim owns TypeScript; don't let mason enable ts_ls too
      automatic_enable = { exclude = { "ts_ls" } },
    },
  },
  {
    -- Resolves the Lua library for lua_ls on demand, so plugin APIs complete
    -- correctly when editing this config (including lazy-loaded plugins).
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
}
