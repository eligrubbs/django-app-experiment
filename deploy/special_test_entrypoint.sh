#!/usr/bin/env bash
####
# Test Shell Script
#
# Script intended to run directly on docker image and execute tests after some startup commands
#
####

./deploy/pre-start.sh

python manage.py test
