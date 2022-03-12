(module module.plugins.telescope
	{autoload {telescope telescope
	           actions telescope.actions}})

(telescope.load_extension "projects")
(telescope.load_extension "file_browser")

(telescope.setup {:defaults 
									{:mappings 
									 {:i {:<C-j> "move_selection_next"
												:<C-k> "move_selection_previous"
												:<C-d> actions.delete_buffer}}}})
