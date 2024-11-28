#!/bin/bash

input_file="repo_names.txt"
output_file="gha_lines.txt"
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
      workflow_dir="$repo_dir/.github/workflows"
      if [ -d "$workflow_dir" ]; then
        total_lines=0
        while IFS= read -r file; do
          line_count=$(wc -l < "$file")
          total_lines=$((total_lines + line_count))
        done < <(find "$workflow_dir" -type f)
        echo "$total_lines" >> "$output_file"
      else
        echo "" >> "$output_file"
      fi
    else
      echo "" >> "$output_file"
    fi
  fi
done < "$input_file"

echo "Total lines in GitHub Action workflow files have been saved to $output_file"
