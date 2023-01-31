(module module.plugins.bufferline
  {autoload {bufferline bufferline}})

(bufferline.setup {:options {:offsets {1 {:filetype "NvimTree"
                                          :text "File Explorer"}}}})

