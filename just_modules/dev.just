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

# spin up infrastructure like it is in prod
@up:
    # To mimic production, start all services that are NOT the app
    # Then, run a docker compose command on the app container BEFORE the main app spins up
    # This represents running a pre-deploy command like in prod

    # build the dev app
    just dev build
    just stack prune

    # spin up dependent services
    just stack::project=dev stack up-not-app

    # run pre-deploy command
    just dev predeploy

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
