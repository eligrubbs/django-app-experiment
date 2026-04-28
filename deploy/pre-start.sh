#!/usr/bin/env bash
####
# Prod Pre-Start Shell Script
#
# Script intended to run directly on production docker image BEFORE the main service
# The app image should be deployed right after this completes.
#
####

python manage.py collectstatic --noinput
