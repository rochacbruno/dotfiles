#!/bin/bash 

sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bck

# Update arch mirrors
reflector \
  --verbose \
  -c PT -c ES -c US \
  --protocol https \
  --sort rate \
  --latest 10 \
  | sudo tee /etc/pacman.d/mirrorlist
