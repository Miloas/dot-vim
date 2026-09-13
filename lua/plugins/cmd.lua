return {
  {
    "mrjones2014/legendary.nvim",
    keys = {
      {
        "<leader><leader>",
        function()
          require("legendary").find()
        end,
        mode = { "n", "x", "o" },
        desc = "commands",
      },
    },
    config = function()
      require("legendary").setup({
        commands = {
          { ":Lazy", description = "plugins manager" },
          { ":Mason", description = "language server manager" },
          {
            ":Format",
            ":lua require'conform'.format({ async = true, lsp_format = 'fallback' })<CR>",
            description = "format buffer",
          },
          -- `:LspRestart`/`:LspInfo` were removed in nvim 0.12
          { ":lsp restart", description = "restart language server" },
          { ":checkhealth vim.lsp", description = "language server status" },
          { ":GitConflictListQf", description = "show all git conflict files" },
          { ":GitStatus", ":lua require'telescope.builtin'.git_status{}<CR>", description = "show git status" },
          {
            ":GitBufferCommits",
            ":lua require'telescope.builtin'.git_bcommits{}<CR>",
            description = "show buffer's git commits history",
          },
          {
            ":GitCommits",
            ":lua require'telescope.builtin'.git_commits{}<CR>",
            description = "show git commits history",
          },
          { ":GitBranches", ":lua require'telescope.builtin'.git_branches{}<CR>", description = "show git branches" },
          { ":GitStash", ":lua require'telescope.builtin'.git_stash{}<CR>", description = "show stash stack" },
          { ":TSToolsAddMissingImports", description = "[TS] add missing imports" },
          { ":TSToolsOrganizeImports", description = "[TS] organize imports" },
          { ":TSToolsSortImports", description = "[TS] sort imports" },
          { ":TSToolsRemoveUnusedImports", description = "[TS] remove unused imports" },
          { ":TSToolsRenameFile", description = "[TS] rename file" },
          { ":TSToolsRemoveUnused", description = "[TS] remove unused" },
          { ":TSToolsFixAll", description = "[TS] fix all" },
          { ":TSToolsGoToSourceDefinition", description = "[TS] goto source definition" },
          { ":TSToolsFileReferences", description = "[TS] file references" },
        },
        include_builtin = false,
        include_legendary_cmds = false,
      })
    end,
  },
}
