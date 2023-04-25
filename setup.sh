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

# Install yq
sudo snap install yq

# Check if the yq command is available
if ! command -v yq &> /dev/null; then
  echo "Error: yq is not installed. Install it using 'sudo snap install yq'"
  exit 1
fi

# Define the YAML file containing the environment variables
YAML_FILE="env_vars.yaml"

# Function to add an environment variable to ~/.bashrc if it doesn't already exist
add_env_var() {
  local name="$1"
  local value="$2"

  grep -qxF "export $name=$value" ~/.bashrc

  if [ $? -ne 0 ]; then
    echo "Adding environment variable $name to ~/.bashrc"
    echo "export $name=$value" >> ~/.bashrc
  else
    echo "Environment variable $name already exists in ~/.bashrc"
  fi
}

# Read environment variables from the YAML file and add them to ~/.bashrc
yq eval '. as $o ireduce ({}; . * $o)' "$YAML_FILE" | while IFS="=" read -r env_var_name env_var_value; do
  add_env_var "$env_var_name" "$env_var_value"
done

# Source the .bashrc file to make the environment variables available immediately
source ~/.bashrc

chmod +x mircok8s/setup.sh
sh mircok8s/setup.sh

# Bootstrap flux
flux bootstrap github \
  --owner=\$GH_USER \ 
  --repository=\$FLUX_REPOSITORY \
  --personal \
  --path bootstrap