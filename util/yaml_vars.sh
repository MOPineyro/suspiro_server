#!/bin/bash

# Install yq
sudo snap install yq

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "yq is required but not found. Please install yq."
    exit 1
fi

# Read the YAML file and append the environment variables to ~/.bashrc
while IFS="=" read -r key value; do
    echo "export $key='$value'" >> ~/.bashrc
done < <(yq e -o=json "$1" | jq -r 'to_entries | .[] | "\(.key)=\(.value)"')

echo "Environment variables have been added to ~/.bashrc."


# Source the .bashrc file to make the environment variables available immediately
source ~/.bashrc
