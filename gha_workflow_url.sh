#!/bin/bash

input_file="repo_names.txt"
output_file="gha_workflow_url.txt"
base_dir="$HOME/laa-code"

# Create or clear the output file
> "$output_file"

# Function to get the default branch of a repository
get_default_branch() {
  repo_dir="$1"
  git -C "$repo_dir" symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
}

# Function to check if the workflows directory has files
check_workflows() {
  repo_dir="$1"
  default_branch=$(get_default_branch "$repo_dir")
  workflows_dir="$repo_dir/.github/workflows"
  if [ -d "$workflows_dir" ] && [ "$(ls -A "$workflows_dir")" ]; then
    echo "https://github.com/ministryofjustice/$repo_name/tree/$default_branch/.github/workflows"
  else
    echo "-"
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
      gha_url=$(check_workflows "$repo_dir")
      echo "$gha_url" >> "$output_file"
    else
      echo "Repository directory $repo_dir does not exist." >> "$output_file"
    fi
  fi
done < "$input_file"

echo "GitHub Action workflow URLs have been saved to $output_file"
