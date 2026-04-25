# Create the CI pipeline

We have previously set up the basics to create a django application locally.

Now, we want to leverage the docker-first development practices as the foundation for a continuous integration system. This system will allow us to create reliable, traceable, code artifacts which can easily be promoted to a production environment. It will also enable easy rollbacks.

What will this system look like? Simple.

- The main branch is the currently running state of the repository.
- To physically make a change you can
    1. make a commit directly to main (don't do this...)
    2. make a branch with your changes, open a PR, merge changes.
- Run tests often to ensure that new changes don't break anything
    - Run unit tests after each commit
        - covered as part of pre-commit hooks
    - Run expensive integration / e2e tests when merged / pushed to main
- After passing tests on merge / push to main, create artifact
    - create docker image of current repo
    - push image to image repository

The output of a good CI/CD pipeline is an artifact which you have confidence in to supercede it's parent artifact.
Coupled with a continuous deployment pipeline, you can move that built artifact up the environment hierarchy (dev, uat, prod) to release it.

## Testing

### Unit Tests

Create unit tests often. These tests should test individual components, and should not really rely on any dependencies like docker. They should be very fast to run.

Use the django test suite functionality to create and run these tests.

### Integration / E2E Tests

These tests mock or use real dependencies (a mail server, OAUTH provider, Database) to test the applications behavior.

Use docker + django tests, and other tech potentially, to do this.

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
