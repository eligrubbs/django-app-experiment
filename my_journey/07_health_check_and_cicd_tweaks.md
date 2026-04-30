# Creating a Health Check

A health check route gives a public, but usually obscure url for services to check if the website is fully up and running!

Check this: https://medium.com/@iman.rameshni/django-health-check-89fb6ad39b0c

So that it is less obvious how to exploit the health route, we configure a variable so that the health check is semi-obfuscated.

This is controlled by the app by expecting string environment variable `FOR_DJANGO_HEALTH_CHECK_SECRET`.


## CI / CD

We just made tweaks to prevent running builds / deployments on PR creations and edits. This saves on resources while still ensuring tests run when they should.
