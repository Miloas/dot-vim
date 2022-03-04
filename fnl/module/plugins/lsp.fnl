(module module.plugins.project
  {autoload {ncmp_lsp cmp_nvim_lsp
             illuminate illuminate
             lsp lspconfig}})

(let [capabilities (vim.lsp.protocol.make_client_capabilities {})]
  (ncmp_lsp.update_capabilities capabilities)
  (lsp.gopls.setup {:capabilities capabilities :on_attach illuminate.on_attach})
  (lsp.rust_analyzer.setup {:capabilities capabilities :on_attach illuminate.on_attach})
  (lsp.pyright.setup {:capabilities capabilities 
                      :on_attach illuminate.on_attach
                      :python {:analysis {:extraPaths [(.. (vim.fn.system "pdm info --packages") "/lib")]}
                               :pythonPath (vim.fn.system "pdm info --python")}})
  ;; (lsp.jdtls.setup {:capabilities capabilities})
  (lsp.tailwindcss.setup {:capabilities capabilities})
  (lsp.graphql.setup {:capabilities capabilities})
  (lsp.tsserver.setup {:capabilities capabilities :on_attach illuminate.on_attach}))