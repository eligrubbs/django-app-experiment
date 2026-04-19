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
    just dev prune

    # spin up dependent services
    cd {{ justfile_directory() }} && docker compose --env-file=.env --profile=not-app up -d

    # run pre-deploy command
    just dev predeploy

    # deploy as normal
    cd {{ justfile_directory() }} && docker compose --env-file=.env watch web

# destroy docker infrastructure
@down:
    just dev prune
    cd {{ justfile_directory() }} && docker compose --env-file=.env down

# build the dev docker image
@build:
    cd {{ justfile_directory() }} && docker compose --env-file=.env build


# run pre-deploy scripts on dev infrastructure
@predeploy:
    cd {{ justfile_directory() }} && docker compose --env-file=.env run --rm web /app/deploy/pre-deploy.sh

# remove all dangling images.
@prune:
    # These accumulate as you make changes, and run docker compose up and such
    cd {{ justfile_directory() }} && docker image prune -f


@manage *args:
    cd {{ justfile_directory() }} && docker compose --env-file=.env run --rm web python manage.py {{ args }}


# remove docker compose volumes holding dev data you've accumulated
@down-volumes:
    cd {{ justfile_directory() }} && docker compose --env-file=.env down -v
