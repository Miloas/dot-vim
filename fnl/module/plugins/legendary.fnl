(module module.plugins.legendary 
	{autoload {legendary legendary}})

(legendary.setup {:commands [
	{1 ":GitConflictListQf" :description "Show all git confilict files" :opts []}
	{1 ":PackerInstall" :description "Install plugins" :opts []}
	{1 ":PackerSync" :description "Sync plugins" :opts []}]
	:include_builtin false})
