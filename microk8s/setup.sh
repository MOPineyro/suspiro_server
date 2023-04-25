#!/bin/bash
# Function to add a line to a file if it doesn't already exist
add_line_to_file() {
  local line="$1"
  local file="$2"

  grep -qxF "$line" "$file"

  if [ $? -ne 0 ]; then
    echo "Adding line to $file:"
    echo "$line"
    echo "$line" >> "$file"
  else
    echo "Line already exists in $file:"
    echo "$line"
  fi
}

# Configure microk8s permissions
sudo usermod -a -G microk8s $(whoami)

# Create/update the .kube/config file with MicroK8s configuration if it doesn't exist or if it doesn't contain MicroK8s configuration
if [ ! -f $HOME/.kube/config ] || ! grep -q "microk8s-cluster" $HOME/.kube/config; then
    echo "Updating $HOME/.kube/config with MicroK8s configuration"
    microk8s config > $HOME/.kube/config
else
    echo "$HOME/.kube/config already contains MicroK8s configuration"
fi
sudo chown -R suspiro ~/.kube
newgrp microk8s

# Create an alias for kubectl to use microk8s kubectl
add_line_to_file "alias kubectl='microk8s kubectl'" "$HOME/.bash_aliases"
add_line_to_file "alias helm='microk8s.helm'" "$HOME/.bash_aliases"

# Enable required MicroK8s add-ons
microk8s enable dns helm3 dashboard storage community traefik

# Source aliases
. \$HOME/.bash_aliases