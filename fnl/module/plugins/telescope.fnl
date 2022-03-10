(module module.plugins.telescope
	{autoload {telescope telescope}})

(telescope.load_extension "projects")
(telescope.load_extension "file_browser")

(telescope.setup {:defaults 
									{:mappings 
									 {:i {:<C-j> "move_selection_next"
												:<C-k> "move_selection_previous"}}}})
