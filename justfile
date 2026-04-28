# This is the global justfile. Running `just` in this or and child directory will target this file.
# If you create a `justfile` in a child directory, that one will be used instead as the main one!

mod stack "just_modules/stack.just"
mod ci "just_modules/ci.just"
mod dev "just_modules/dev.just"
mod setup "just_modules/setup.just"


# Helper recipe to cancel any github action if it is hanging
force-cancel-github-action run:
    #!/usr/bin/env bash

    # Make sure you set PERSONAL_GITHUB_TOKEN_TO_CANCEL_WORKFLOWS in your local .env file
    cd '{{ justfile_directory() }}'

    export $(grep -v '^#' .env | xargs)

    curl -L \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $PERSONAL_GITHUB_TOKEN_TO_CANCEL_WORKFLOWS" \
    -H "X-GitHub-Api-Version: 2026-03-10" \
    https://api.github.com/repos/eligrubbs/django-app-experiment/actions/runs/{{ run }}/force-cancel
