#!/usr/bin/env bash
# https://www.reddit.com/r/swaywm/comments/fjsrk9/comment/fkvjctd/?utm_source=share&utm_medium=web2x&context=3

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
        ' | grep -v __i3 \
          | wofi --show dmenu --prompt='Focus a window' | {
    read -r id name
    swaymsg "[con_id=$id]" focus
}
