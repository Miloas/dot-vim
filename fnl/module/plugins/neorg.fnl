(module module.plugins.neorg 
	{autoload {neorg neorg}})

(neorg.setup {:load {:core.defaults {}
		     :core.norg.dirman {:config {:workspaces {:work "~/notes/work"}}}}})
