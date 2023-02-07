(module module.plugins.gitsigns
  {autoload {gitsigns gitsigns
	     wk which-key}})

(import-macros {: map!} :macros)

; https://github.com/lewis6991/gitsigns.nvim
(fn on_attach [bufnr]
	(wk.register {"]c" ["&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'" "next hunk"]
		      "[q" ["&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'" "prev hunk"]}
		     {:buffer bufnr :expr true})

        (wk.register {:h {:name "gitsigns"
			  :b [gitsigns.toggle_current_line_blame "toggle blame"]
			  :S [gitsigns.stage_buffer "stage buffer"]
			  :u [gitsigns.undo_stage_buffer "undo stage hunk"]
			  :R [gitsigns.reset_buffer "reset buffer"]
			  :p [gitsigns.preview_hunk "preview hunk"]
			  :d [gitsigns.diffthis "diff this"]
			  :D [(lambda [] (gitsigns.diffthis "~")) "diff HEAD"]
			  :q [gitsigns.setqflist "set qflist"]
			  :Q [(lambda [] (gitsigns.setqflist "all")) "set qflist all"]}}
		      {:prefix "<leader>" :buffer bufnr})

        (wk.register {:h {:name "gitsigns"
			  :s [gitsigns.stage_hunk "stage hunk"]
			  :r [gitsigns.reset_hunk "reset hunk"]}}
		      {:prefix "<leader>" :mode ["n" "v"] :buffer bufnr})

	(map! [o x] :ih ":<C-U>Gitsigns select_hunk<CR>" {:buffer bufnr}))

(gitsigns.setup {:on_attach on_attach
		 :signs {:untracked {:text "│"}}
		 :current_line_blame_formatter_opts {:relative_time true}
		 :current_line_blame_opts {:delay 0}
		 :preview_config {:border "rounded"}})
