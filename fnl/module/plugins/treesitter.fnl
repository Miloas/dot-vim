(module module.plugins.treesitter
  {autoload {treesitter-config nvim-treesitter.configs
             treesitter-parsers nvim-treesitter.parsers}})

(let [parser_configs (treesitter-parsers.get_parser_configs {})]
  (set parser_configs.norg_meta {:install_info {:url "https://github.com/nvim-neorg/tree-sitter-norg-meta"
                                                :files [ "src/parser.c" ]
                                                :branch "main"}})
  (set parser_configs.norg_table {:install_info {:url "https://github.com/nvim-neorg/tree-sitter-norg-table"
                                                :files [ "src/parser.c" ]
                                                :branch "main"}}))

(treesitter-config.setup 
  {:ensure_installed "maintained"
   :sync_install false
   :rainbow {:enable true :extended_mode true :max_file_lines nil}
   :highlight {:enable true
               :additional_vim_regex_highlighting false}})