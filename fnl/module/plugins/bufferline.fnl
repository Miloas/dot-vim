(module module.plugins.bufferline
  {autoload {bufferline bufferline}})

(bufferline.setup {:options {:offsets [{:filetype "NvimTree"
                                          :text "File Explorer"}]}})
