#!/bin/bash

# Install yq
sudo snap install yq

# # Check if the yq command is available
# if ! command -v yq &> /dev/null; then
#   echo "Error: yq is not installed. Install it using 'sudo snap install yq'"
#   exit 1
# fi

# Define the YAML file containing the environment variables
YAML_FILE="../env_vars.yaml"

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
for env_var_name in $(yq read "$YAML_FILE" -k); do
  env_var_value=$(yq read "$YAML_FILE" "$env_var_name")
  add_env_var "$env_var_name" "$env_var_value"
done

# Source the .bashrc file to make the environment variables available immediately
source ~/.bashrc
