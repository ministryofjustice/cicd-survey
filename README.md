# CI/CD Survey

These scripts to analyse the CircleCI and GitHub Action configurations across the LAA git repos.

Each script produces a data file with the same filename base. e.g. `gha_files.sh` generates `gha_files.csv`.

The idea is to copy-paste the data into spreadsheet columns. This LAA data is pasted into [CI/CD systems in use in LAA](https://docs.google.com/spreadsheets/d/1aIzWBiz8LLVWhVnPmINm6Q7YEFserHBUqKP9Tak9KYQ/edit?gid=0#gid=0)

Mostly the data is in txt format, but where we need multi-line text, its in CSV. Each line corresponds to the repo in the respective line in `repo_names.txt`.

NB The data is not committed because it has info on repos which are internal, whereas this repo is public, and the data includes names of committers.

## Usage

1. Update [LAA Systems - As-is use](https://docs.google.com/spreadsheets/d/1mBibsaJfx-Uq0ajHVaFdkWYKImXfzH9JuB8afq1aPmU/edit?usp=sharing) to add or remove any systems and their GitHub URLs (column Z)

2. Copy those updates across to [CI/CD systems in use in LAA](https://docs.google.com/spreadsheets/d/1aIzWBiz8LLVWhVnPmINm6Q7YEFserHBUqKP9Tak9KYQ/edit?gid=0#gid=0) - specifically Application, Team and Github URL. Lines with duplicate GitHub URLs need to be removed.

3. Copy the GitHub URLs from [CI/CD systems in use in LAA](https://docs.google.com/spreadsheets/d/1aIzWBiz8LLVWhVnPmINm6Q7YEFserHBUqKP9Tak9KYQ/edit?gid=0#gid=0) (from the 2nd row) and paste them `github_urls.txt` (replacing existing list).

4. Run repo_names.sh - updates repo_names.txt, which is used by subsequent scripts

    ```sh
    ./repo_names.sh
    ```

5. Run clone.sh - to clone all the repos to a local directory, which will be used by subsequent scripts

    ```sh
    ./clone.sh
    ```

6. Run analysis scripts. Each one produces an output file .txt or .csv - open this in an editor, Copy the whole contents, and 'Paste by value' into the appropriate column of [CI/CD systems in use in LAA](https://docs.google.com/spreadsheets/d/1aIzWBiz8LLVWhVnPmINm6Q7YEFserHBUqKP9Tak9KYQ/edit?gid=0#gid=0):

    ```sh
    ./circleci_config_urls.sh
    ./circleci_lines.sh
    ./circleci_workflows.sh
    ./circleci_authors.sh
    ./circleci_created.sh

    ./gha_workflow_url.sh
    ./gha_lines.sh
    ./gha_files.sh
    ./gha_authors.sh
    ./gha_created.sh
    ```

7. Manually update the "Used for CD" column, saying whether CircleCi or GHA is used for the Continuous Delivery/Deployment, according to the workflow names.
