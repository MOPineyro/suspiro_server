#!/bin/bash

# Install Nix
curl -L https://nixos.org/nix/install | sh

# Add Nix to the shell environment
. \$HOME/.nix-profile/etc/profile.d/nix.sh

# Enable Nix experimental features
mkdir -p \$HOME/.config/nix
echo "experimental-features = nix-command flakes" >> \$HOME/.config/nix/nix.conf

# Install MicroK8s using snap
sudo snap install microk8s --classic
