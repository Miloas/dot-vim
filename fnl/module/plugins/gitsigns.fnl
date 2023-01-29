(module module.plugins.gitsigns
  {autoload {gitsigns gitsigns
	     wk which-key}})

(import-macros {: defmap } :macros)

; https://github.com/lewis6991/gitsigns.nvim
(fn on_attach [bufnr]
	(wk.register {"]c" {1 "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'" 2 "next hunk"}
		      "[q" {1 "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'" 2 "prev hunk"}}
		     {:buffer bufnr :expr true})

        (wk.register {:h {:name "gitsigns"
			  :b {1 gitsigns.toggle_current_line_blame 2 "toggle blame"}
			  :S {1 gitsigns.stage_buffer 2 "stage buffer"}
			  :u {1 gitsigns.undo_stage_buffer 2 "undo stage hunk"}
			  :R {1 gitsigns.reset_buffer 2 "reset buffer"}
			  :p {1 gitsigns.preview_hunk 2 "preview hunk"}
			  :d {1 gitsigns.diffthis 2 "diff this"}
			  :D {1 (lambda [] (gitsigns.diffthis "~")) 2 "diff HEAD"}
			  :q {1 gitsigns.setqflist 2 "set qflist"}
			  :Q {1 (lambda [] (gitsigns.setqflist "all")) 2 "set qflist all"}}}
		      {:prefix "<leader>" :buffer bufnr})

        (wk.register {:h {:name "gitsigns"
			  :s {1 gitsigns.stage_hunk 2 "stage hunk"}
			  :r {1 gitsigns.reset_hunk 2 "reset hunk"}}}
		      {:prefix "<leader>" :mode {1 "n" 2 "v"} :buffer bufnr})

	(defmap [o x] :ih ":<C-U>Gitsigns select_hunk<CR>" {:buffer bufnr}))

(gitsigns.setup {:on_attach on_attach
		 :signs {:untracked {:text "│"}}
		 :current_line_blame_formatter_opts {:relative_time true}
		 :current_line_blame_opts {:delay 0}
		 :preview_config {:border "rounded"}})
