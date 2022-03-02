(module module.plugins.autopairs
	{autoload {cmp cmp
						 npairs nvim-autopairs
						 cmp_autopairs nvim-autopairs.completion.cmp}})

(npairs.setup {})
(cmp.event:on "confirm_done" (cmp_autopairs.on_confirm_done {:map_char {:tex ""}}))
