(module module.plugins.treesitter
  {autoload {treesitter-config nvim-treesitter.configs}})

(treesitter-config.setup 
  {:ensure_installed "maintained"
   :sync_install false
   :rainbow {:enable true :extended_mode true :max_file_lines nil}
   :indent {:enable true}
   :highlight {:enable true
               :additional_vim_regex_highlighting false}})
