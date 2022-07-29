function fish_user_key_bindings

  # Bind fzf select command to Ctrl+R.
  bind \cr fzf_select_command
  # Bind fzf change directory to Ctrl+F.
  bind \cf fzf_change_directory

  # Prevent terminal from closing when typing Ctrl-D (EOF).
  bind \cd delete-char

end
