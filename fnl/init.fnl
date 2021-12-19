(module init
  {require {util util}})

(def req util.safe-require)

;; coq_nvim
;; https://github.com/ms-jpq/coq_nvim#autostart-coq
(set vim.g.coq_settings 
     {:auto_start "shut-up"
      :keymap.recommended false
      :keymap.pre_select true
      :display.pum.fast_close false})

(req "module.plugins")
(req "module.settings")
(req "module.bindings")
(req "module.lsp")
