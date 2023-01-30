(module module.plugins.nvim-tree
	{autoload {nvim-tree nvim-tree
						 nvim-tree-events nvim-tree.events
						 bufferline-api bufferline.api
						 nvim-tree-view nvim-tree.view}})

(nvim-tree.setup {:view {:hide_root_folder true}
									:hijack_cursor true
									:update_focused_file {:enable true}
									:filters {:custom {1 ".git$"}}})

(nvim-tree-events.subscribe "TreeOpen" (lambda [] (bufferline-api.set_offset nvim-tree-view.View.width)))
;; https://github.com/nvim-tree/nvim-tree.lua/issues/1545
;; mouse resize may not work
(nvim-tree-events.subscribe "Resize" (lambda [size] (bufferline-api.set_offset nvim-tree-view.View.width)))
(nvim-tree-events.subscribe "TreeClose" (lambda [] (bufferline-api.set_offset 0)))
