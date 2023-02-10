(module module.plugins.hop
	{autoload {cmp cmp
                   lspkind lspkind
                   luasnip luasnip
                   ft_func luasnip.extras.filetype_functions
                   snippets snippets}})

(import-macros {: map!} :macros)

(fn tab-func [fallback] 
  (if (cmp.visible) 
     (cmp.confirm {:behavior cmp.ConfirmBehavior.Replace
                   :select true})
     (luasnip.expand_or_jumpable)
     (luasnip.expand_or_jump)
     (fallback)))

(fn shift-tab-func [fallback] 
  (if (cmp.visible) 
     (cmp.select_prev_item {})
     (luasnip.jumpable -1)
     (luasnip.jump -1)
     (fallback)))

(cmp.setup {:snippet {:expand (fn [args] (luasnip.lsp_expand args.body))}
            :formatting {:format (lspkind.cmp_format {:mode "symbol" :maxwidth 50})}
            :mapping {:<C-K> (cmp.mapping.select_prev_item {})
                      :<C-J> (cmp.mapping.select_next_item {})
                      :<C-D> (cmp.mapping.scroll_docs -4)
                      :<C-F> (cmp.mapping.scroll_docs 4)
                      :<C-Space> (cmp.mapping.complete {})
                      :<C-E> (lambda [fallback] 
                                (let [copilot_keys (vim.fn.copilot#Accept {})]
                                  (if (= copilot_keys "") 
                                    (fallback {}) 
                                    (vim.api.nvim_feedkeys copilot_keys "i" true))))
                      :<Tab> (cmp.mapping {:i tab-func
                                           :s tab-func})
                      :<S-Tab> (cmp.mapping {:i shift-tab-func
                                             :s shift-tab-func})}
            :sources [{:name "nvim_lsp"} {:name "luasnip"} {:name "conjure"}]})

(luasnip.add_snippets "go" snippets.go)
(luasnip.config.set_config {:updateevents "TextChanged,TextChangedI"
                            :ft_func ft_func.from_pos_or_filetype})

;; LUASNIP ;;
;; https://github.com/arsham/shark/blob/master/lua/plugins/luasnip/init.lua
(map! [i s] :<C-l> (lambda [] (when (luasnip.choice_active {}) (luasnip.change_choice 1))) {:silent true})
(map! [i s] :<C-h> (lambda [] (when (luasnip.choice_active {}) (luasnip.change_choice -1))) {:silent true})
