# Goals & Introduction

## Introduction

This directory contains a series of markdown files that document my journey to creating a Django App that follows best practices.

This is not meant to be a tutorial, but more of an audit log. I will learn that somethings I did in the past are bad, and will undo them.


## Goals

I want to create a Django full-stack SaaS app. I want everything about the app to follow best development practices (a little nebulous but let me clarify later). The feeling I should have towards the end of this is complete understanding of every part of the application lifecycle. 

The app will have no interesting features. It will be built out insofar as there will be users, subscriptions, and some demonstrations about

Buzzword dump so you understand a little more

Developer Experience:

1. `uv` for project / python management
2. `pre-commit` for consistent commits
3. use conventional commits for all git commit messages
4. practice trunk-based development as much as possible
    - keep one version of code, small updates with clear rollback strategy.

Technology:
1. Django for web application
2. htmx and alpine js for frontend interactivity
3. Tailwind and DaisyUI for styling frontend.
4. Celery for backgroudn workers
5. Redis for caching
6. Postgres for database


Deployment Strategy:
1. Docker for containerizing application
    - brings consistency
    - makes migrating vendors easier
2. Neon for database
    - branching feature makes testing super easy
3. Render for containerized deployments / redis
    - I like their product the best out of the others I have tried
4. Custom AWS ECR repository for storing pre-built images

CI/CD:
1. Github actions for orchestration of testing / deployment
2. blacksmith runners to perform CI/CD actions

