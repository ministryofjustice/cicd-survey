#!/bin/bash

# Set base directory where repositories are cloned
BASE_DIR="$HOME/laa-code"

# Input and output files
REPO_NAMES_FILE="repo_names.txt"
OUTPUT_FILE="circleci_created.txt"

# Empty the output file if it exists
> "$OUTPUT_FILE"

# Loop through each repo name in repo_names.txt
while read -r REPO; do
    # Define the path to the repository
    REPO_PATH="$BASE_DIR/$REPO"

    # Check if the repository exists
    if [ -d "$REPO_PATH" ]; then
        # Check if the .circleci/config.yml file exists in the repo
        if [ -f "$REPO_PATH/.circleci/config.yml" ]; then
            # Get the date of the first commit to .circleci/config.yml in "YYYY-MM-DD" format
            FIRST_COMMIT_DATE=$(git -C "$REPO_PATH" log --diff-filter=A --date=format:"%Y-%m-%d" --format="%ad" -- ".circleci/config.yml" | tail -1)

            # If the file has a first commit, add the date to the output file
            if [ -n "$FIRST_COMMIT_DATE" ]; then
                echo "$FIRST_COMMIT_DATE" >> "$OUTPUT_FILE"
            else
                # If no commit date is found, add a blank line
                echo "" >> "$OUTPUT_FILE"
            fi
        else
            # If .circleci/config.yml does not exist, add a blank line
            echo "" >> "$OUTPUT_FILE"
        fi
    else
        # If the repo directory does not exist, add a blank line
        echo "" >> "$OUTPUT_FILE"
    fi
done < "$REPO_NAMES_FILE"

echo "Processing complete. Dates have been written to $OUTPUT_FILE."
