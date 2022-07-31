(module module.plugins.nvim-surround
  {autoload {nvim_surround nvim-surround}})

(nvim_surround.setup {:delimiters {:invalid_key_behavior (lambda [char] {1 char 2 char})}})


