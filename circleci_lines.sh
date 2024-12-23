#!/bin/bash

input_file="repo_names.txt"
output_file="circleci_lines.txt"
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
    if [ -d "$repo_dir" ]; then
      config_file="$repo_dir/.circleci/config.yml"
      if [ -f "$config_file" ]; then
        line_count=$(wc -l < "$config_file" | awk '{print $1}')
        echo "$line_count" >> "$output_file"
      else
        echo "-" >> "$output_file"
      fi
    else
      echo "0" >> "$output_file"
    fi
  fi
done < "$input_file"

echo "Total lines in CircleCI config files have been saved to $output_file"