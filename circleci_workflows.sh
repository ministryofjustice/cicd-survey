#!/bin/bash

input_file="repo_names.txt"
output_file="circleci_workflows.csv"
base_dir="$HOME/laa-code"

# Create or clear the output file
> "$output_file"

# Read the input file line by line
while IFS= read -r repo_name; do
  if [ -z "$repo_name" ]; then
    # Preserve blank lines
    echo "" >> "$output_file"
  else
    repo_dir="$base_dir/$repo_name"
    config_file="$repo_dir/.circleci/config.yml"
    if [ -f "$config_file" ]; then
      workflow_names=$(yq e '.workflows | keys | .[]' "$config_file" | grep -v '^version$')
      formatted_workflow_names=$(echo "$workflow_names" | awk '{printf "%s\n", $0}')
      echo "\"$formatted_workflow_names\"" >> "$output_file"
    else
      echo "" >> "$output_file"
    fi
  fi
done < "$input_file"

echo "CircleCI workflow names have been saved to $output_file"
