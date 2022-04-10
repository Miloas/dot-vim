(module module.plugins.legendary 
	{autoload {legendary legendary}})

(legendary.setup {:commands [
	{1 ":GitConflictListQf" :description "Show all git confilict files"}
	{1 ":PackerInstall" :description "Install plugins"}
	{1 ":PackerSync" :description "Sync plugins"}]
	:include_builtin false})
