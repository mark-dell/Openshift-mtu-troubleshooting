#!/bin/bash

# Get the list of nodes
nodes=$(oc get nodes | awk 'NR > 1 {print $1}')

# Loop through each node
for node in $nodes; do
    # Run the debug command on each node and return the NIC's max MTU
    oc debug node/$node -- bash -c 'ip link show master bond0 | awk -F ": " '\''{print $2}'\'' | grep -v "^$" | xargs -I % ip -d link list dev % | grep -E "minmtu|maxmtu" | awk '\''{for(i=1;i<=NF;i++) if($i=="minmtu") min=$(i+1); else if($i=="maxmtu") max=$(i+1); if(min && max) print "minmtu " min " maxmtu " max; min=""; max=""}'\'''
done

