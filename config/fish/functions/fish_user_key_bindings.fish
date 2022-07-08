function fish_user_key_bindings

  # Bind peco select command to Ctrl+R.
  bind \cr peco_select_command
  # Bind peco change directory to Ctrl+F.
  bind \cf peco_change_directory

  # Prevent terminal from closing when typing Ctrl-D (EOF).
  bind \cd delete-char

end
