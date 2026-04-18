# django-app-experiment

## Motivation

This repository exists as a playground for me to learn how to deploy a python web application using the Django web framework as a solo developer. 

Lots of large companies have successfully scaled Django applications to huge sizes. The ecosystem is mature and the framework is opinionated; this means I can leverage the learnings pretty directly from large open source projects out there.

Companies I have heard used Django to scale:

- [Posthog](https://github.com/posthog/posthog)
- [Sentry](https://github.com/getsentry/sentry)
- Instgram
- Pintrest
- Photoroom

## Goal

The goal of this repository is get a website deployed while observing engineering best practices.

I won't get everything right the first time.

### Phase 1: Semi-uninformed Dev Basics

I do not know a lot about Django, but I know enough about general python development to know how to set a solid foundation. 

The goal of this phase is to create a development framework that encompasses using Django and supporting technologies. This phase will include:

- pre-commit hooks for code consistency
- guides on how to write tests and to track code coverage
- using docker for consistent testing where applicable
- github workflows for CI, running all tests
- Establish how and where to document important decisions / learnings

We are NOT focused on building specific Django features.

## Phase 2: Basic Webapp Boilerplate Discovery

Leverage the development framework set up in phase 1 to explore common Django features.

- Creating Users
- Auth
- payments

## Phase 3: Touching the Real World

Exploring in development only gives a lot of velocity. Once I have a foundation for things this phase will kick off.

- AWS ECR for docker image storage
- github workflows to automatically build images and store them
- render.com for web and database hosting
- Terraform to manage all of that infrastructure
