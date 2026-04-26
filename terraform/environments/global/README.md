# Global HCP Terraform Workspace

This workspace is designed to create variable sets in HCP Terraform.

This is downstream from the bootstrap step because you don't need admin credentials to run this, just the terraform cli!

It creates a globally applied set for common services so other environments can use custom providers
    - e.g. the RENDER_API_KEY is set so in `production` environment, you can use the render provider to make a web service
