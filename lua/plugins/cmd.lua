return {
  {
    "mrjones2014/legendary.nvim",
    keys = {
      {
        "<leader><leader>",
        function()
          require("legendary").find()
        end,
        mode = { 'n', 'x', 'o' },
        desc = "commands"
      }
    },
    config = function()
      require("legendary").setup({
        commands = {
          { ":Lazy", description = "plugins manager" },
          { ":Format", description = "plugins manager" },
          { ":LspRestart", description = "restart language server" },
          { ":GitConflictListQf", description = "show all git conflict files" },
          { ":GitStatus", ":lua require'telescope.builtin'.git_status{}<CR>", description = "show git status" },
          { ":GitBufferCommits", ":lua require'telescope.builtin'.git_bcommits{}<CR>", description = "show buffer's git commits history" },
          { ":GitCommits", ":lua require'telescope.builtin'.git_commits{}<CR>", description = "show git commits history" },
          { ":GitBranches", ":lua require'telescope.builtin'.git_branches{}<CR>", description = "show git branches" },
          { ":GitStash", ":lua require'telescope.builtin'.git_stash{}<CR>", description = "show stash stack" },
          { ":TypescriptAddMissingImports", description = "[TS] add missing imports" },
          { ":TypescriptOrganizeImports", description = "[TS] organize imports" },
          { ":TypescriptRenameFile", description = "[TS] rename file" },
          { ":TypescriptRemoveUnused", description = "[TS] remove unused" },
          { ":TypescriptFixAll", description = "[TS] fix all" },
          { ":TypescriptGoToSourceDefinition", description = "[TS] TS4.7 goto" }
        },
        include_builtin = false,
        include_legendary_cmds = false
      })
    end,
  }
}
