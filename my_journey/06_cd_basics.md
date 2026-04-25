# Continuous Deployment Basics

We have a very basic hello-world application. We are now ready to get it set up in a continuous deployment workflow!

The benefits of doing this step early is that as the code evolves, you learn where things need to change in the process.

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

### HCP Terraform Continued

- Go run the `global` workspace in terraform. All that workspace does it create a place to store all secrets / variables for real infrastructure managing workspaces like `production` / `staging` to reference.
- Go to the HCP Terraform UI, and enter the relevant API tokens / secrets / variables into the global variable set that was created
