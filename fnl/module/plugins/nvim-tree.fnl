(module module.plugins.nvim-tree
	{autoload {nvim-tree nvim-tree}})

(nvim-tree.setup {:view {:hide_root_folder true}
									:filters {:custom {1 ".git$"}}})
