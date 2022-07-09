#!/usr/bin/env bash
#
# Navigate to a firefox tab.
#

# Select a browser tab by its title.
# https://github.com/balta2ar/brotab/
tab=$(brotab list \
  | cut -d $'\t' -f1-2 \
  | column -t -s $'\t' \
  | wofi -aib \
  --width 500 \
  --prompt "" \
  --dmenu | {
  read -r id name
  echo $name

  # Focus the tab in the browser.
  brotab activate $id
})

# Find the Firefox window the tab is in now.
# https://www.reddit.com/r/swaywm/comments/fjsrk9/comment/fkvjctd/
swaymsg -t get_tree | jq -r '
        # descend to workspace or scratchpad
        .nodes[].nodes[]
        # save workspace name as .w
        | {"w": .name} + (
                if .nodes then # workspace
                        [recurse(.nodes[])]
                else # scratchpad
                        []
                end
                + .floating_nodes
                | .[]
                # select nodes with no children (windows)
                | select(.nodes==[])
        )
        | ((.id | tostring) + "\t "
        # remove markup and index from workspace name,
        # replace scratch with "[S]"
        + (.w | gsub("^[^:]*:|<[^>]*>"; "") | sub("__i3_scratch"; "[S]"))
        + "\t " +  .name)
        ' | grep "$tab" | {
    read -r id name
    swaymsg "[con_id=$id]" focus
}
