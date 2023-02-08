(module module.plugins.legendary 
	{autoload {legendary legendary}})

(legendary.setup {:commands [
	{1 ":PackerSync" :description "Sync plugins" :opts []}
	{1 ":PackerInstall" :description "Install plugins" :opts []}

	{1 ":GitConflictListQf" :description "Show all git confilict files" :opts []}
	{1 ":GitStatus" 2 ":lua require'telescope.builtin'.git_status{}<CR>" :description "Show git status" :opts []}
	{1 ":GitBufferCommits" 2 ":lua require'telescope.builtin'.git_bcommits{}<CR>" :description "Show buffer's git commits" :opts []}
	{1 ":GitCommits" 2 ":lua require'telescope.builtin'.git_commits{}<CR>" :description "Show buffer's git commits" :opts []}
	{1 ":GitBranches" 2 ":lua require'telescope.builtin'.git_branches{}<CR>" :description "Show buffer's git commits" :opts []}
	{1 ":GitStash" 2 ":lua require'telescope.builtin'.git_stash{}<CR>" :description "Show buffer's git commits" :opts []}

	{1 ":Neogit" :description "[Neogit] open magit pannel"}

	{1 ":TypescriptAddMissingImports" :description "[TS] Add missing imports"}
	{1 ":TypescriptOrganizeImports" :description "[TS] Organize imports"}
	{1 ":TypescriptRenameFile" :description "[TS] Rename file"}
	{1 ":TypescriptRemoveUnused" :description "[TS] Remove unused"}
	{1 ":TypescriptFixAll" :description "[TS] Fix all"}
	{1 ":TypescriptGoToSourceDefinition" :description "[TS] TS4.7 goto"}]
	:include_builtin false
	:include_legendary_cmds false})
