# nvim

Personal Neovim config. Plugin manager is [lazy.nvim](https://github.com/folke/lazy.nvim),
colorscheme is catppuccin-mocha, leader is `<Space>`.

Targets **Neovim 0.12+ / HEAD**. It uses `vim.lsp.config()`/`vim.lsp.enable()` and
nvim-treesitter's `main` branch, neither of which exists on 0.11.

## Setting up on a new machine

```sh
brew install neovim --HEAD
brew install tree-sitter-cli   # NOT the `tree-sitter` formula -- see below
brew install rustup lazygit ripgrep
```

Then launch `nvim` (lazy.nvim bootstraps itself and installs everything) and run
`:checkhealth` — it should come back with no warnings.

### tree-sitter-cli

The single most likely thing to bite you. Homebrew's `tree-sitter` formula is only
the *library* Neovim links against; the CLI that compiles parsers lives in a
separate `tree-sitter-cli` formula. Without it, every parser fails to build with a
bare `ENOENT ... (cmd): 'tree-sitter'`. The config detects this and prints the fix.

Install it from a package manager, **not npm** — nvim-treesitter requires >= 0.26.1.

### rustup

Homebrew's `rustup` no longer ships `rustup-init`, so any old `~/.cargo/bin`
symlinks pointing at it are dead. Its shims are keg-only and must be on `PATH`:

```sh
echo 'export PATH="/opt/homebrew/opt/rustup/bin:$PATH"' >> ~/.zshenv
rustup default stable
rustup component add rust-analyzer
```

That last line matters: if the component is missing, the rustup `rust-analyzer`
shim "falls back" to itself and loops until the process dies.

### Upgrading Neovim later

`brew reinstall --HEAD` is not a thing, and plain `brew upgrade` will not move a
HEAD install. Use:

```sh
brew upgrade --fetch-HEAD neovim
```

If `nvim` starts failing with `Library not loaded: libtree-sitter.N.dylib`, that
means Homebrew moved tree-sitter out from under the old build — same command fixes it.

## Layout

```
init.lua              compat shims -> options -> autocmds -> keymaps -> lazy
lua/config/
  compat.lua          shims removed APIs for Miloas/miloas.snippets (see below)
  options.lua         options, disabled providers, gotmpl filetype
  keymaps.lua         non-plugin keymaps
  autocmds.lua        opens nvim-tree on startup (without stealing focus)
  lazy.lua            lazy.nvim bootstrap + setup
lua/plugins/          one file per area; every file returns a lazy.nvim spec
```

## Tooling

| Area | What's used |
| --- | --- |
| LSP | `gopls` `lua_ls` `pyright` `eslint` `tailwindcss` `quick_lint_js` `sourcekit` `zls` `relay_lsp` |
| TypeScript | `typescript-tools.nvim` (not `ts_ls`) |
| Rust | `rustaceanvim` + `rust-analyzer` |
| Lua config | `lazydev.nvim` (resolves plugin `require`s for `lua_ls`) |
| Format | `oxfmt` (js/ts/jsx/tsx/json), `stylua`, `ruff`, `gofmt`, `rustfmt`, `zigfmt`, `swift_format` |
| Complete | `nvim-cmp` + `LuaSnip` + Copilot |
| Find | `telescope` (`fzf-native`, `file-browser`) |
| Treesitter | `main` branch; parsers installed to `stdpath('data')/site` |

Servers not in Mason (`gopls`, `pyright`, `rust-analyzer`, ...) are expected on
`PATH`. Mason auto-installs `lua_ls`, `eslint`, `tailwindcss`, `quick_lint_js`.

```
:Mason          manage tools
:Lazy           manage plugins
:lsp restart    restart a server  (`:LspRestart` was removed in 0.12)
:checkhealth    diagnose
```

## Keymaps

`<leader><leader>` opens [legendary](https://github.com/mrjones2014/legendary.nvim)
with every command; which-key shows the rest as you type.

| Group | |
| --- | --- |
| `<leader>f` | find (files / buffers / recent) |
| `<leader>/` | live grep from the git root |
| `<leader>b` | buffer; `<leader>1..9` jump by position |
| `<leader>w` | window; `-` and `/` split |
| `<leader>h` | gitsigns hunks, `<leader>gs` lazygit |
| `<leader>x` | diagnostics / quickfix (trouble) |
| `<leader>p` | project; `<leader>pt` toggles the file tree, `<leader>0` reveals the current file |
| `<leader>m` | module; `<leader>mr` LSP rename |
| `<leader>s` | text; `sr` search-replace, `st` todos |
| `<leader>v` / `<bs>` | grow / shrink treesitter selection |

LSP: `gd` `gr` `gI` `gt` definitions/references/implementations/types, `K` hover,
`<C-.>` code action, `]d` `[d` diagnostics (`]e` errors, `]w` warnings).

Arrow keys are multicursor (`<up>`/`<down>` add a cursor, `<c-n>` next match,
`<esc>` clears). `s` is `substitute.nvim`, not vim's substitute.

## Fonts

`JetBrainsMono Nerd Font` (set via `guifont` for GUI clients). Icons come from
`mini.icons`, which also mocks `nvim-web-devicons`.

## Known stopgap

`lua/config/compat.lua` shims `nvim-treesitter.ts_utils`, `nvim-treesitter.locals`,
and the old `vim.treesitter.set_query`/`get_query`/`query.get_node_text` aliases,
all removed upstream. It exists purely so `Miloas/miloas.snippets` keeps loading —
the real fix belongs in that repo, after which this file can be deleted.
