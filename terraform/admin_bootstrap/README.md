# Admin Bootstrap

Make sure you are logged in (run `terraform login` and paste the credential).

Only run IaC stuff in this repo by using the justfile.

## Infrastructure this directory creates

1. An HCP Terraform Workspace
    - This workspace holds the remote state of this directory
2. A global variable set containing
    1. The same API token you are using to run this job
        - This grants other workspaces the ability to create and manage variable sets
        - In reality, if you had a professional HCP Terraform setup, you could use Team tokens to restrict access to downstream jobs but right now the only type of token that can create terraform variable sets are user tokens which can also do anything else in HCP Terraform...

This step can contain other things later if it requires an admin to run it. It is designed to be run by a super user (hence the name admin_bootstrap).

For example, if you wanted to use AWS ECR to manage your containers, you'd make variables to read the AWS credentials on the admin's machine, set up the infra, create outputs for other workspaces to reference (the arn of the ECR repo, the arn and names of roles with least-priviledge access you made to read / write to the repo, etc.)
