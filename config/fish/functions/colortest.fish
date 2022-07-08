#
# Display the current color palette.
# https://askubuntu.com/a/821163
#

function colortest

  for i in (seq 0 255)
    printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
    if test $i -eq 15 -o $i -gt 15 -a (math "($i - 15) % 6") -eq 0
      printf "\n"
    end
  end

end
