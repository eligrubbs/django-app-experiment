tailwind_exec := "tailwindcss-v4.2.2"

@defaut:
    just --list dev

# Live-updates output.css. Takes over terminal.
tailwind:
    # Set working directory to project root. Not sure this matters because in input.css I only explicitely declare what I scan
    {{ tailwind_exec }} \
    --cwd {{ justfile_directory() }} \
    -i {{ justfile_directory() }}/frontend_assets/css/input.css \
    -o {{ justfile_directory() }}/static/css/output.css \
    --watch --optimize

# Spin up all services except the webapp. So you can run it locally
@not-app-up:
    # To mimic production, start all services that are NOT the app
    # Then, run a docker compose command on the app container BEFORE the main app spins up
    # This represents running a pre-deploy command like in prod

    # build the dev app
    just dev build
    just stack prune

    # spin up dependent services
    just stack::project=dev stack not-app-up

    # run pre-deploy command
    just dev predeploy

# spin up infrastructure like it is in prod
@up:
    # start supporting services
    just dev not-app-up

    # deploy with live reload
    just stack::project=dev stack watch-app

# destroy docker infrastructure
@down:
    just stack::project=dev stack down

# build the dev docker image
@build:
    just stack::project=dev stack build

# run pre-deploy scripts on dev infrastructure
@predeploy:
    just stack::project=dev stack predeploy

@manage *args:
    just stack::project=dev stack manage {{ args }}

# remove docker compose volumes holding dev data you've accumulated
@down-volumes:
    just stack::project=dev stack down-volumes

# Populate dev env with some accounts, data, etc.
@data-up:
    #!/usr/bin/env bash
    set -euo pipefail

    # Create an admin user
    just dev manage createsuperuser


# For manage cmds that need to run on your machine (makemigrations, etc.)
@local-manage *args:
    #!/usr/bin/env bash
    set -euo pipefail

    cd '{{ justfile_directory() }}'

    # Use your .env file you made for your own dev environment
    export $(grep -v '^#' .env | xargs)

    # Make sure some variables are fixed to work from your machine's perspective, not inside the docker container
    export FOR_DJANGO_DATABASE_HOST="127.0.0.1"

    python manage.py {{ args }}

# Create admin account in local postgres db. fake@admin.com password `fake`
@make-admin:
    DJANGO_SUPERUSER_PASSWORD=fake just dev local-manage createsuperuser --username admin --email fake@admin.com --no-input
