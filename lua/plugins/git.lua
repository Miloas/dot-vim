return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      default_mappings = false,
    },
    keys = {
      { "co", ":GitConflictChooseOurs<CR>", desc = "choose ours" },
      { "ct", ":GitConflictChooseTheirs<CR>", desc = "choose theirs" },
      { "cb", ":GitConflictChooseBoth<CR>", desc = "choose both" },
      { "c0", ":GitConflictChooseNone<CR>", desc = "choose none" },
      { "]x", ":GitConflictNextConflict<CR>", desc = "next conflict" },
      { "[x", ":GitConflictPrevConflict<CR>", desc = "prev conflict" },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gs", ":LazyGit<CR>", desc = "lazygit" },
    },
  },
}
