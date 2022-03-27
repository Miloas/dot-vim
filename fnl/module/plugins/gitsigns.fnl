(module module.plugins.gitsigns
  {autoload {gitsigns gitsigns}})

(import-macros {: defmap } :macros)

(fn on_attach [bufnr]
	(defmap [n] "]c" "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'" {:buffer bufnr :expr true})
	(defmap [n] "[c" "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'" {:buffer bufnr :expr true})

	(defmap [n] :<leader>hb gitsigns.toggle_current_line_blame {:buffer bufnr})
	(defmap [n v] :<leader>hs gitsigns.stage_hunk {:buffer bufnr})
	(defmap [n] :<leader>hS gitsigns.stage_buffer {:buffer bufnr})
	(defmap [n] :<leader>hu gitsigns.undo_stage_hunk {:buffer bufnr})
	(defmap [n v] :<leader>hr gitsigns.reset_hunk {:buffer bufnr})
	(defmap [n] :<leader>hR gitsigns.reset_buffer {:buffer bufnr})
	(defmap [n] :<leader>hp gitsigns.preview_hunk {:buffer bufnr})
	(defmap [n] :<leader>hd gitsigns.diffthis {:buffer bufnr})
	(defmap [n] :<leader>hD (lambda [] (gitsigns.diffthis "~")) {:buffer bufnr})

	(defmap [n] :<leader>hq gitsigns.setqflist {:buffer bufnr})
	(defmap [n] :<leader>hQ (lambda [] (gitsigns.setqflist "all")) {:buffer bufnr})

	(defmap [o x] :ih ":<C-U>Gitsigns select_hunk<CR>" {:buffer bufnr}))

(gitsigns.setup {:on_attach on_attach
								 :current_line_blame_formatter_opts {:relative_time true}
								 :current_line_blame_opts {:delay 0}
								 :word_diff true
								 :preview_config {:border "rounded"}})
