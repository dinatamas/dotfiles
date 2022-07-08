# See other creative uses here:
# https://github.com/peco/peco/wiki/Sample-Usage
function peco_select_command

  begin
    # Commands to include:
    history
  end | peco --layout=bottom-up | read foo

  if [ $foo ]
    commandline $foo
  else
    commandline ''
  end

end
