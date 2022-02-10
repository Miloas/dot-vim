(module module.plugins.hop
	{autoload {cmp cmp
						 luasnip luasnip}})

(cmp.setup {:snippet {:expand (fn [args] (luasnip.lsp_expand args.body))}
            :mapping {:<C-K> (cmp.mapping.select_prev_item {})
                      :<C-J> (cmp.mapping.select_next_item {})
                      :<C-D> (cmp.mapping.scroll_docs -4)
                      :<C-F> (cmp.mapping.scroll_docs 4)
                      :<C-Space> (cmp.mapping.complete {})
                      :<C-E> (cmp.mapping.close {})
                      :<Tab> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Replace
                                                   :select true})}
            :sources [{:name "nvim_lsp"} {:name "luasnip"}]})