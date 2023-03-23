#!/usr/bin/bash

# Prints a single line showing number of running containers 
# sums podman + docker 
# example:
#   $ ./container_count.sh
#   1/2/15
#
# being:
# [running containers]/[total containers]/[total images]

total_podman_images=$(podman image list --format=json | jq '. | length')
total_podman_containers=$(podman container list -a --format=json | jq '. | length')
total_podman_running=$(podman container list --format=json | jq '. | length')
echo -n "🦫 ${total_podman_running}/${total_podman_containers}/${total_podman_images}"

