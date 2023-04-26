#!/bin/bash

# Check if input file is provided
if [ -z "$1" ]; then
    echo "Usage: ./insert_script_to_bashrc.sh <script_file>"
    exit 1
fi

# Variables
script_file="$1"
marker_start="# BEGIN INSERTED SCRIPT: $script_file"
marker_end="# END INSERTED SCRIPT: $script_file"
bashrc_file="$HOME/.bashrc"
temp_bashrc_file="$HOME/.bashrc.temp"

# Remove the previous insertion if it exists
sed "/$marker_start/,/$marker_end/d" "$bashrc_file" > "$temp_bashrc_file"

# Insert the new script at the bottom of .bashrc
{
  cat "$temp_bashrc_file"
  echo ""
  echo "$marker_start"
  cat "$script_file"
  echo "$marker_end"
} > "$bashrc_file"

# Clean up
rm "$temp_bashrc_file"

echo "Script $script_file has been inserted into $bashrc_file."
