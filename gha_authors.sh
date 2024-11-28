#!/bin/bash

input_file="repo_names.txt"
output_file="gha_authors.csv"
base_dir="$HOME/laa-code"

# Create or clear the output file
> "$output_file"

# Function to process email addresses
process_email() {
  local email="$1"
  if [[ "$email" == *@users.noreply.github.com ]]; then
    echo "$email" | sed 's/.*+\(.*\)@users.noreply.github.com/\1/'
  elif [[ "$email" == *@digital.justice.gov.uk ]]; then
    echo "$email" | sed 's/@digital.justice.gov.uk//'
  else
    echo "$email"
  fi
}

# Read the input file line by line
while IFS= read -r repo_name; do
  if [ -z "$repo_name" ]; then
    # Preserve blank lines
    echo "" >> "$output_file"
  else
    repo_dir="$base_dir/$repo_name"
    if [ -d "$repo_dir" ]; then
      cd "$repo_dir" || continue
      # Get the commit history for the past year for .github/workflows directory
      git log --since="1 year ago" --pretty=format:"%ae" --numstat -- .github/workflows > /tmp/gitlog.txt
      author_lines=$(awk 'NF==3 {lines[author]+=$1} NF==1 {author=$1} END {for (a in lines) print a, lines[a]}' /tmp/gitlog.txt | \
      sort -k2 -nr | awk '{print $1 " " $2}')
      # Process email addresses and format author lines with newline characters
      formatted_author_lines=$(echo "$author_lines" | while read -r line; do
        email=$(echo "$line" | awk '{print $1}')
        lines_added=$(echo "$line" | awk '{print $2}')
        processed_email=$(process_email "$email")
        echo "$processed_email $lines_added"
      done | awk '{printf "%s\n", $0}')
      # Write to output file in the original directory
      echo "\"$formatted_author_lines\"" >> "$OLDPWD/$output_file"
      cd - > /dev/null || continue
    else
      echo "" >> "$OLDPWD/$output_file"
    fi
  fi
done < "$input_file"

echo "Recent authors and lines added have been saved to $output_file"
