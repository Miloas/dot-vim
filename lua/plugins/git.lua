return {
  {
    "akinsho/git-conflict.nvim",
    version = false,
    opts = {
      default_mappings = false,
    },
    keys = {
      { "co", ":GitConflictChooseOurs<CR>", { desc = "choose ours" } },
      { "ct", ":GitConflictChooseTheirs<CR>", { desc = "choose theirs" } },
      { "cb", ":GitConflictChooseBoth<CR>", { desc = "choose both" } },
      { "c0", ":GitConflictChooseNone<CR>", { desc = "choose none" } },
      { "]x", ":GitConflictNextConflict<CR>", { desc = "next conflict" } },
      { "[x", ":GitConflictPrevConflict<CR>", { desc = "prev conflict" } },
    },
    config = function(_, opts)
      require("git-conflict").setup(opts)
    end,
  },
  {
    "TimUntersberger/neogit",
    config = function()
      require("neogit").setup()
    end
  },
  {
    "kdheepak/lazygit.nvim",
    keys = {
      { "<leader>gs", ":LazyGit<CR>", { desc = "lazygit" } },
    }
  }
}
