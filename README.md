# Setting up on a new machine

Requires Neovim 0.12+ (nvim-treesitter's `main` branch and `vim.lsp.config`).

```sh
brew install neovim --HEAD
brew install tree-sitter-cli   # NOT the `tree-sitter` formula
brew install rustup            # then: rustup default stable
```

`tree-sitter-cli` is the one that catches people out. Homebrew's `tree-sitter`
formula is only the library Neovim links against; the CLI that compiles parsers
lives in `tree-sitter-cli`. Without it every parser fails to build with a bare
`ENOENT ... 'tree-sitter'`.

Homebrew's `rustup` no longer ships `rustup-init`, so its shims live in a
keg-only dir that must be on `PATH`:

```sh
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
rustup component add rust-analyzer   # else the shim recurses and dies
```

Then check everything with `:checkhealth` (should be clean) and `:Lazy sync`.

# LSP

```
see plugins/lsp.lua
```

# Fonts

```
// codicon for lspkind
https://github.com/microsoft/vscode-codicons/blob/main/dist/codicon.ttf

```

# how to use nvim tree

```
https://docs.rockylinux.org/books/nvchad/nvchad_ui/nvimtree/
```

# homebrew latest nvim
https://github.com/neovim/neovim/issues/25255
```
brew uninstall lpeg;
brew install lpeg;
brew install nvim --HEAD
```

# Mason install formatter
```
:MasonInstall oxfmt
:MasonInstall ruff
:MasonInstall stylua
```
