(module module.plugins.legendary 
	{autoload {legendary legendary}})

(legendary.setup {:commands [
	{1 ":GitConflictListQf" :description "Show all git confilict files" :opts []}
	{1 ":PackerInstall" :description "Install plugins" :opts []}
	{1 ":GitStatus" 2 ":lua require'telescope.builtin'.git_status{}<CR>" :description "Show git status" :opts []}
	{1 ":GitBufferCommits" 2 ":lua require'telescope.builtin'.git_bcommits{}<CR>" :description "Show buffer's git commits" :opts []}
	{1 ":GitCommits" 2 ":lua require'telescope.builtin'.git_commits{}<CR>" :description "Show buffer's git commits" :opts []}
	{1 ":GitBranches" 2 ":lua require'telescope.builtin'.git_branches{}<CR>" :description "Show buffer's git commits" :opts []}
	{1 ":GitStash" 2 ":lua require'telescope.builtin'.git_stash{}<CR>" :description "Show buffer's git commits" :opts []}
	{1 ":PackerSync" :description "Sync plugins" :opts []}]
	:include_builtin false
	:include_legendary_cmds false})
