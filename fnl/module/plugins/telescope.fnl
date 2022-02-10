(module module.plugins.telescope
	{autoload {telescope telescope}})

(telescope.load_extension "projects")
(telescope.load_extension "file_browser")
