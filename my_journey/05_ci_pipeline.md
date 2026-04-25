# Create the CI pipeline

We have previously set up the basics to create a django application locally.

Now, we want to leverage the docker-first development practices as the foundation for a continuous integration system. This system will allow us to create reliable, traceable, code artifacts which can easily be promoted to a production environment. It will also enable easy rollbacks.

What will this system look like? Simple.

- The main branch is the currently running state of the repository.
- To physically make a change you can
    1. make a commit directly to main (don't do this...)
    2. make a branch with your changes, open a PR, merge changes.
- Run tests often to ensure that new changes don't break anything
    - Run tests after each commit / push
        - covered as part of pre-commit hooks
    - Run expensive integration / e2e tests when merged / pushed to main
- After passing tests on merge / push to main, create artifact
    - create docker image of current repo
    - push image to image repository

The output of a good CI/CD pipeline is an artifact which you have confidence in to supercede it's parent artifact.
Coupled with a continuous deployment pipeline, you can move that built artifact up the environment hierarchy (dev, uat, prod) to release it.

## Building Artifacts

Github workflows will be used.

However, if you are working in an organization, use [blacksmith.sh](https://blacksmith.sh) runners instead of github native runners. They are fast and cheap.

For this project, we will use github default workers.

Look at `.github/workflows/build.yaml`. That github action kicks off to build a new image every time there is a push to main, or you manually trigger it.

You'll have to change the destination artifact repository to be your account's. See the below for what that even means.

## Storing Artifacts

For simplicity, we will use the github container registry. For this free project, you get unlimited artifacts!

The github container registry will recognize when you push your first image.

Since we are choosing to use the github container repository, there is no configuration we have to do except change the destination container repository like so:

```
...
- name: Docker meta
        id: meta
        uses: docker/metadata-action@v6
        with:
            images: |
                ghcr.io/<your account / org>/<your repository>
...
```

## Testing

The application will always ship with it's tests, even in a Dockerfile. Invoking tests should always be done with the management script.

Due to the availability of docker, we blur the lines heavily between strict unit tests, integration, and E2E tests. We believe pushing the complication as close to prod as possible in development will make everything easier when we get there.

Therefore, to run tests, you should you the convenience `just` recipes in `ci` or `dev` which orchestrate spinning up a docker compose stack, running tests, and tearing everything down.

1. On push to the remote repository, dockerized tests are run on your machine, you won't be able to push until they pass.
    - This provides a soft gurantee that tests are always passing!
2. On `Build` github action invocation, the artifact is built
