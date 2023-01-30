(module module.plugins.nvim-tree
	{autoload {nvim-tree nvim-tree
						 nvim-tree-events nvim-tree.events
						 bufferline-api bufferline.api
						 nvim-tree-view nvim-tree.view}})

(nvim-tree.setup {:view {:hide_root_folder true}
									:hijack_cursor true
									:update_focused_file {:enable true}
									:filters {:custom {1 ".git$"}}})
