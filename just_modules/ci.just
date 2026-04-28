tailwind_exec := "tailwindcss-v4.2.2"


# Shows all commands
@default:
    just --list ci


# Minify the tailwind assets.
@tailwind-minify:
    {{ tailwind_exec }} \
    --cwd {{ justfile_directory() }} \
    -i {{ justfile_directory() }}/frontend_assets/css/input.css \
    -o {{ justfile_directory() }}/static/css/output.css \
    --minify \
    && echo "" >> {{ justfile_directory() }}/static/css/output.css

# Run tests which rely on dockerized services
@test:
    #!/usr/bin/env bash
    set -euo pipefail

    # # run pre-deploy command
    # just dev predeploy
    # # spin up testing services
    # docker compose -p testing -f docker-compose.yaml --env-file=.env.testing up -d --wait

    # # run tests
    # set +e
    # # uv run --env-file=.env.testing python manage.py test
    # docker compose -p testing -f docker-compose.yaml --env-file=.env.testing run --rm web python manage.py test
    # status=$?
    # set -e

    # # destroy testing services
    # just ci down-test

    # exit $status

    # To mimic production, start all services that are NOT the app
    # Then, run a docker compose command on the app container BEFORE the main app spins up
    # This represents running a pre-deploy command like in prod

    # build the dev app
    just stack::project=testing stack build
    just stack prune

    # spin up dependent services
    just stack::project=testing stack up-not-app

    # run pre-deploy command
    just stack::project=testing stack predeploy

    # run test
    set +e
    just stack::project=testing stack exec ./deploy/special_test_entrypoint.sh
    # just stack::project=testing stack manage test
    status=$?
    set -e

    just stack::project=testing stack down

    exit $status

# Destroy the docker compose stack for testing
@down:
    just stack::project=testing stack down
