function peco_change_directory

  begin
    # Directories to include:
    echo '~/'
    echo '~/.config'
    find ~/ -maxdepth 3 -type d -not -path '*/.*'
    find /opt/repo -maxdepth 3 -type d -not -path '*/.*'
    find ./ -maxdepth 3 -type d -not -path '*/.*'
  end | sed -e 's/\/$//' | awk '!a[$0]++' | \
  peco --layout=bottom-up | perl -pe 's/([ ()])/\\\\$1/g' | read foo

  if [ $foo ]
    builtin cd $foo
    commandline -r ''
    commandline -f repaint
  else
    commandline ''
  end

end
