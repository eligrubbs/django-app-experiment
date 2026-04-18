# Dockerize Locally

Before thinking about deploying to production, we need to get the project set up so that it works well with Docker containers.

As far as I am aware, nothing I am doing requires me to

## Dockerizing Things

1. Create a `Dockerfile` in the parent directory
    - This is a copied dockerfile that I have accumulated through many projects
2. Create `docker-compose.yaml` file next to it.
    - This will build our image locally
3. Create `.dockerignore` file and put in it all of the files/directories you DONT want in your final image
    - Very important because the current setup has the context for the docker image as the parent directory for the project. There is no isolated sub-directory for the whole django app. Therefore lots of config / dev-specific / unrelated files and directories could be copied to the final image.


### Hot-Reloading in Dev

For development purposes, we want code changes to reflect in our project without having to re-build the image. The `runserver` command rebuilds the app for us on code changes,
but inside a docker container, the files don't change by default! To remedy this, we can use a volume mounted 1-to-1 between our local code and app directory, or we can use a 1-way watch configuration to watch for changes locally, then copy the changes to the docker container.

We prefer to use the watch option (see the docker compose) because it is the best balance between keeping the docker container isolated, and remaining agile to local dev changes.

## Utility scripts

Now that docker is set up, we create utility `just` recipes to spin the web server up and down
