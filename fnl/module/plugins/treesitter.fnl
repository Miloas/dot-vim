(module module.plugins.treesitter
  {autoload {treesitter-config nvim-treesitter.configs}})

(treesitter-config.setup 
  {:ensure_installed ["rust" "go" "python" "lua" "zig" "typescript" "fennel"]
   :textobjects {:select {:enable true
                          :lookahead true
                          :keymaps {:af "@function.outer"
                                    :if "@function.inner"
                                    :aa "@parameter.outer"
                                    :ia "@parameter.inner"}}
                 :move {:enable true
                        :set_jumps true
                        :goto_next_start {"]m" "@function.outer"
                                          "]]" "@class.outer"
                                          "]a" "@parameter.outer"}
                        :goto_next_end {"]M" "@function.outer"
                                        "][" "@class.outer"
                                        "]A" "@parameter.outer"}
                        :goto_previous_start {"[m" "@function.outer"
                                              "[[" "@class.outer"
                                              "[a" "@parameter.outer"}
                        :goto_previous_end {"[M" "@function.outer"
                                            "[]" "@class.outer"
                                            "[A" "@parameter.outer"}}}
   :sync_install false
   :rainbow {:enable true :extended_mode true :max_file_lines nil}
   :indent {:enable true :disable ["javascript" "typescript" "python" "yaml"]}
   :highlight {:enable true
               :additional_vim_regex_highlighting true}})
