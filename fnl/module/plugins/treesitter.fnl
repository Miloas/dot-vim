(module module.plugins.treesitter
	{autoload {treesitter-config nvim-treesitter.configs}})

(treesitter-config.setup 
  {:ensure_installed "maintained"
   :sync_install false
   :highlight {:enable true
               :additional_vim_regex_highlighting false}})