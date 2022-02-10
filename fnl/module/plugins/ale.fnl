(module module.plugins.ale
  {autoload {nvim aniseed.nvim}})

(set nvim.g.ale_linters
  {:javascript [:standard]
	 :typescript ["tsserver"]
   :go ["gopls"]})