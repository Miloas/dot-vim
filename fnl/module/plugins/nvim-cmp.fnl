(module module.plugins.hop
	{autoload {cmp cmp
                   lspkind lspkind
                   luasnip luasnip}})

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
                      :<Tab> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Replace
                                                   :select true})}
            :sources [{:name "nvim_lsp"} {:name "luasnip"}]})