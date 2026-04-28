# Continuous Deployment Basics

We have a very basic hello-world application. We are now ready to get it set up in a continuous deployment workflow!

The benefits of doing this step early is that as the code evolves, you learn where things need to change in the process.

## Preparing app for production

I realized I forgot to do some important things before deployment. The list of changes I made are:
1. create `deploy/start.sh` to start the app
2. remove `collectstatic` manage command from `deploy/pre-deploy.sh` since that runs on a separate container prior to the real prod container
3. Create a production-specific settings file `hairbrush/settings_production.py` and fill it with stuff to recognize the cloudflare proxy and to secure the session

## Deployment Services

- Compute: Render.com
    - Easy to use and control compute
- Database: Neon.com
    - Nice free tier, branches for testing later on will be very nice
- Website DNS Records: Cloudflare
    - has API keys we can use to change DNS records, etc.

## Managing Infrastructure

- Terraform
- HCP Terraform
    - Service to remotely manage state

## Creating everything

### HCP Terraform

Choosing to use HashiCorp Platform's cloud Terraform product is the simplest way to get a secure remote state set up for terraform.

We want a single source-of-truth for as much infrastructure as we can get. That way it will be easy to destroy everything that is costing you money later on.

- Install terraform CLI
- Go create an account on HCP
- Create an organization
- Go to your user settings and make an API token
    - This will allow your local machine to tell HCP Terraform to run things on their remote job runners to manage infrastructure.
- locally, run `terraform login` and paste that token. You are ready to use Terraform!
- Go follow the instructions in `terraform/admin_bootstrap` directory to create the foundational admin-invoked workspace.


### Web Services - Render.com

- Go create an account
- Create a workspace, copy that ID
- Go to your user settings, create an API key and copy it.

### Database - Neon.com

- Go create an account
- Create an organization
- Create spending limit

Neon does not support an official terraform provider. Because of that we will not try and use terraform to manage that infrastructure.

### DNS Records - Cloudflare

- Make sure your custom domain has cloudflare as it's nameservers
- Create an API key that only allows DNS edits

### Github Image Access

Follow directions [here](https://render.com/docs/deploying-an-image#github)

In summary:

- Create a personal access token (classic) that has `read:packages` permission
- Copy that and the username for later

### HCP Terraform Continued

- Go to each workspace and run `terraform init`. That creates the empty workspaces. The `global` workspace might look for the other environments, so do this first!
- In each HCP Terraform workspace, in the UI, set the Settings > General > Terraform Working Directory to the environment path in this repo (terraform/environments/global).
    - This will allow remote runs to use modules declared in the repo at `terraform/modules`.
- Go run the `global` workspace in terraform. All that workspace does it create a place to store all secrets / variables for real infrastructure managing workspaces like `production` / `staging` to reference.
- For django, create a secret key by running `python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'` and pasting that output into the production variable group.
- Go to the HCP Terraform UI, and enter the relevant API tokens / secrets / variables into the global variable set that was created


### Live in Production

- Go run the `production` workspace
- Make temporary changes to bootstrap the web service.
    - Primarily, you need to launch the service with a manually configured image before letting it reference itself. See the comment in one of the terraform files.
    - In the future, all deploys will happen via a webhook from a github action
- Apply the changes! The infrastructure should be spun up.


## Continous Deployment

We will trigger a github workflow after the container is built that promotes it to production.

You need to add your `RENDER_API_KEY` to the github repository secrets so github workflows can use it.

We add a ci workflow to `test_and_build.yaml` which runs dockerized tests, then builds a docker artifact for the webapp.

We add a deployment github workflow to `deploy.yaml` which automatically deploys the artifact to production after successfully passing the ci workflow.

We use the `deploy_environment.yaml` callable workflow to separate things out, and defer the complicated logic to a script `deploy_server.sh`.

Almost all of this was copied from the [polar.sh repository](https://github.com/polarsource/polar/tree/main/.github/workflows). I just tweaked it so the testing and build/deploy workflows are not separate; Instead the testing + build were combined and they directly trigger a deployment workflow.

We have now configured a workflow to both integrate and deploy code changes.
