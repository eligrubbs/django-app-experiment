#!/usr/bin/env bash
####
# Prod Start Shell Script
#
# Script intended to run directly on production docker image and start the main service
# The app image should be deployed right after this completes.
#
####

# Only use these settings if the environment variable is properly set
if [ "$ENV" = "production" ]; then
    echo "server will set production settings."
    export DJANGO_SETTINGS_MODULE=hairbrush.settings_production
fi

python manage.py collectstatic --noinput

python -m gunicorn --bind 0.0.0.0:$PORT --workers 1 --threads 8 --timeout 0 hairbrush.asgi:application -k uvicorn.workers.UvicornWorker
