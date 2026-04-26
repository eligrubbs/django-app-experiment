#!/usr/bin/env bash
set -o errexit

####
# Pre-Deploy Shell Script
#
# Isolated script intended to run on a separate docker image identical to the app one
# The app image should be deployed right after this completes.
#
# Render.com executes this in production on a separate instance: https://render.com/docs/deploys#pre-deploy-command
#
####

# Only use these settings if the environment variable is properly set
if [ "$ENV" = "production" ]; then
    echo "pre-deploy will set production settings."
    export DJANGO_SETTINGS_MODULE=hairbrush.settings_production
fi

# run database migrations
python manage.py migrate
