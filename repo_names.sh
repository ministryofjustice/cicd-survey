#!/bin/bash

input_file="github_urls.txt"
output_file="repo_names.txt"

# Create or clear the output file
> "$output_file"

# Read the input file line by line
while IFS= read -r line; do
  if [ -z "$line" ]; then
    # Preserve blank lines
    echo "" >> "$output_file"
  else
    # Extract the repository name from the URL
    repo_name=$(echo "$line" | awk -F'/' '{print $5}')
    echo "$repo_name" >> "$output_file"
  fi
done < "$input_file"

echo "Repository names have been saved to $output_file"