#!/bin/bash

# Get the list of nodes
nodes=$(oc get nodes | awk 'NR > 1 {print $1}')

# Loop through each node
for node in $nodes; do
    # Check the number of configured SR-IOV virtual functions
    oc get sriovnetworknodestates.sriovnetwork.openshift.io -n openshift-sriov-network-operator $node -o json | jq -r '.status.interfaces[] | "\(.name) \(.totalvfs)"';
    oc debug node/$node -- bash -c 'for sriovnic in eno8403np1 ens3f1np1; do ip link show dev $sriovnic | grep vf | wc -l | xargs -I {} echo Found the following number of VFs {} for $sriovnic; done'
done
