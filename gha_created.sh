#!/bin/bash

# Set base directory where repositories are cloned
BASE_DIR="$HOME/laa-code"

# Input and output files
REPO_NAMES_FILE="repo_names.txt"
OUTPUT_FILE="gha_created.txt"

# Empty the output file if it exists
> "$OUTPUT_FILE"

# Loop through each repo name in repo_names.txt
while read -r REPO; do
    # Define the path to the repository
    REPO_PATH="$BASE_DIR/$REPO"

    # Check if the repository exists
    if [ -d "$REPO_PATH" ]; then
        # Check if the .github/workflows directory exists in the repo
        if [ -d "$REPO_PATH/.github/workflows" ]; then
            # Get the date of the first commit to any file in .github/workflows in "YYYY-MM-DD" format
            FIRST_COMMIT_DATE=$(git -C "$REPO_PATH" log --diff-filter=A --date=format:"%Y-%m-%d" --format="%ad" -- ".github/workflows/" | tail -1)

            # If the directory has a first commit, add the date to the output file
            if [ -n "$FIRST_COMMIT_DATE" ]; then
                echo "$FIRST_COMMIT_DATE" >> "$OUTPUT_FILE"
            else
                # If no commit date is found, add a blank line
                echo "" >> "$OUTPUT_FILE"
            fi
        else
            # If .github/workflows directory does not exist, add a blank line
            echo "" >> "$OUTPUT_FILE"
        fi
    else
        # If the repo directory does not exist, add a blank line
        echo "" >> "$OUTPUT_FILE"
    fi
done < "$REPO_NAMES_FILE"

echo "Processing complete. Dates have been written to $OUTPUT_FILE."
