# Utility scripts for managing the docker compose stack
# Designed to abstract common tasks
# Set the project and env_file

project := "dev"

env_file := if project == 'dev' { ".env" } else { ".env.testing" }


# List all recipes
@defaut:
    just --list stack

@bob:
    echo '{{project}} {{env_file}}'

# spin up all infrastructure that is not the webapp
@up-not-app:
    cd {{ justfile_directory() }} && docker compose -p={{project}} --env-file={{env_file}} --profile=not-app up -d


# spin up just the app
@up-app:
    cd {{ justfile_directory() }} && docker compose -p={{project}} --env-file={{env_file}} up -d web


# spin up just the app and watch it
@watch-app:
    cd {{ justfile_directory() }} && docker compose -p={{project}} --env-file={{env_file}} watch web


# run pre-deploy scripts on infrastructure
@predeploy:
    # Assumes in your Dockerfile you have copied `./deploy/pre-deploy.sh` to the matching location below...
    cd {{ justfile_directory() }} && docker compose -p={{project}} --env-file={{env_file}} run --rm web /app/deploy/pre-deploy.sh

# Execute the following on the web docker container
@exec *args:
  cd {{ justfile_directory() }} && docker compose -p={{project}} --env-file={{env_file}} run --rm web {{ args }}

# run manage.py against web container
@manage *args:
    cd {{ justfile_directory() }} && docker compose -p={{project}} --env-file={{env_file}} run --rm web python manage.py {{ args }}


# build the web docker image
@build:
    cd {{ justfile_directory() }} && docker compose -p={{project}} --env-file={{env_file}} build


# destroy docker infrastructure
@down:
    just stack prune
    cd {{ justfile_directory() }} && docker compose -p={{project}} --env-file={{env_file}} down


# Tear down local docker compose volumes. Deleting any local stored data
@down-volumes:
    cd {{ justfile_directory() }} && docker compose -p={{project}} --env-file={{env_file}} down -v


# remove all dangling images.
@prune:
    # These accumulate as you make changes, and run docker compose up and such
    cd {{ justfile_directory() }} && docker image prune -f
