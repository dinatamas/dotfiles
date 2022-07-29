function fzf_select_command

  begin
    # Commands to include:
    history
  end | fzf | read foo

  if [ $foo ]
    commandline $foo
  else
    commandline ''
  end

end
