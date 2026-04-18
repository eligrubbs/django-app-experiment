#!/usr/bin/env bash
####
# Pre-Deploy Shell Script
#
# Isolated script intended to run on a separate docker image identical to the app one
# The app image should be deployed right after this completes.
#
####

# collect static
python manage.py collectstatic --noinput

# run database migrations
python manage.py migrate
