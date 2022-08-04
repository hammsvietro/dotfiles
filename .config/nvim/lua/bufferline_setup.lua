 require('bufferline').setup {
    options = {
      indicator_icon = '▎',
      buffer_close_icon = '',
      modified_icon = '●',
      close_icon = '',
      left_trunc_marker = '',
      right_trunc_marker = '',
      color_icons = true,
      numbers = "buffer_id",
      tab_size = 18,
      max_name_length = 22,
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      left_mouse_command = "buffer %d",
      middle_mouse_command = "vertical sbuffer %d",
      diagnostics = "coc",
      diagnostics_update_in_insert = true,
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end
   }
}
