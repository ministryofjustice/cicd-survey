#!/bin/bash

input_file="repo_names.txt"
base_dir="$HOME/laa-code"

# Create the base directory if it doesn't exist
mkdir -p "$base_dir"

# Read the input file line by line
while IFS= read -r repo_name; do
  if [ -z "$repo_name" ]; then
    # Skip blank lines
    continue
  fi

  repo_dir="$base_dir/$repo_name"
  repo_url="git@github.com:ministryofjustice/$repo_name.git"

  if [ -d "$repo_dir" ]; then
    echo "Updating repository: $repo_name"
    cd "$repo_dir" || exit
    git pull
  else
    echo "Cloning repository: $repo_name"
    git clone "$repo_url" "$repo_dir"
  fi
done < "$input_file"

echo "All repositories have been processed."
