(module module.plugins.telescope
	{autoload {telescope telescope
	           actions telescope.actions}})

(telescope.load_extension "projects")
(telescope.load_extension "file_browser")

(telescope.setup {:defaults 
									{:mappings 
									 {:i {:<C-j> "move_selection_next"
												:<C-k> "move_selection_previous"
												:œ (+ actions.send_selected_to_qflist  actions.open_qflist)
												:<C-d> actions.delete_buffer}}}
									:extensions {:fzf {:fuzzy true
																		 :override_generic_sorter true
																		 :override_file_sorter true
																		 :case_mode "smart_case"}}})

(telescope.load_extension "fzf")
