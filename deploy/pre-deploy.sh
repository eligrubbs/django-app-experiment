#!/usr/bin/env bash
####
# Pre-Deploy Shell Script
#
# Isolated script intended to run on a separate docker image identical to the app one
# The app image should be deployed right after this completes.
#
####

# Only use these settings if the environment variable is properly set
if [ "$ENV" = "production" ]; then
    echo "pre-deploy will set production settings."
    export DJANGO_SETTINGS_MODULE=hairbrush.settings_production
fi

# collect static
python manage.py collectstatic --noinput

# run database migrations
python manage.py migrate
