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


### Render.com

Go create an account

### Database - Neon.com

- Go create an account
- Create spending limit
- Create a project called hairbrush with postgres 18
