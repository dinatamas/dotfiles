function fzf_change_directory

  begin
    # Directories to include:
    echo '~/'
    echo '~/.config'
    find /opt/repo -maxdepth 5 -type d -not -path '*/.*'
    find ~/Desktop -maxdepth 3 -type d -not -path '*/.*'
    find ~/Downloads -maxdepth 3 -type d -not -path '*/.*'
    find ./ -maxdepth 3 -type d -not -path '*/.*'
  end | sed -e 's/\/$//' | awk '!a[$0]++' | \
  fzf | perl -pe 's/([ ()])/\\\\$1/g' | read foo

  if [ $foo ]
    builtin cd $foo
    commandline -r ''
    commandline -f repaint
  else
    commandline ''
  end

end
