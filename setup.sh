#!/bin/bash

# # Install Nix
# curl -L https://nixos.org/nix/install | sh

# # Add Nix to the shell environment
# . \$HOME/.nix-profile/etc/profile.d/nix.sh

# # Enable Nix experimental features
# mkdir -p \$HOME/.config/nix
# echo "experimental-features = nix-command flakes" >> \$HOME/.config/nix/nix.conf

# Install MicroK8s using snap
sudo snap install microk8s --classic

# Install flux for GitOps
curl -s https://fluxcd.io/install.sh | sudo bash
sh ./util/yaml_vars.sh env_vars.yaml
sh ./microk8s/setup.sh

# Bootstrap flux
flux bootstrap github \
  --owner=\$GH_USER \ 
  --repository=\$FLUX_REPOSITORY \
  --personal \
  --path bootstrap