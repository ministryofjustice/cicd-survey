#!/bin/bash

input_file="repo_names.txt"
output_file="gha_files.csv"
base_dir="$HOME/laa-code"

# Create or clear the output file
> "$output_file"

# Read the input file line by line
while IFS= read -r repo_name; do
  echo "Processing repository: $repo_name"
  if [ -z "$repo_name" ]; then
    # Preserve blank lines
    echo "Blank line found, preserving in output."
    echo "" >> "$output_file"
  else
    repo_dir="$base_dir/$repo_name"
    if [ -d "$repo_dir" ]; then
      echo "Repository directory exists: $repo_dir"
      workflow_dir="$repo_dir/.github/workflows"
      if [ -d "$workflow_dir" ]; then
        echo "GitHub Action workflows directory found: $workflow_dir"
        file_details=""
        while IFS= read -r file; do
          line_count=$(wc -l < "$file")
          file_name=$(basename "$file")
          file_details+="$file_name $line_count\\n"
          echo "File: $file_name - Lines: $line_count"
        done < <(find "$workflow_dir" -type f)
        # Remove the trailing newline character
        file_details=$(echo -e "$file_details" | sed 's/\\n$//')
        echo "\"$file_details\"" >> "$output_file"
      else
        echo "No GitHub Action workflows directory found for $repo_name."
        echo "\"No GitHub Action workflows directory found.\"" >> "$output_file"
      fi
    else
      echo "Repository directory does not exist: $repo_dir"
      echo "\"Repository directory does not exist.\"" >> "$output_file"
    fi
  fi
done < "$input_file"

echo "GitHub Action workflow file details have been saved to $output_file"
