# Frontend with Vite

Setting up vite for asset management has made me think about a lot of different topics.

Basics on Vite
- https://www.saaspegasus.com/guides/modern-javascript-for-django-developers/integrating-javascript-pipeline-vite/

Guide about docker best practices and how to use django
- https://github.com/nickjj/docker-django-example


The basics is this
1. Create a directory that holds your js, css, frontend specific files
2. Have the vite target outDir be some other directory
3. Add that directory from step 2 to STATICFILES_DIRS so collectstatic pulls from it

Also probably store global images, etc. in some other folder like `/public` (hero.jpg, etc.). Not really sure on this pattern yet though.

There are also small configuration linkings you have to do so django-vite can reference your right files in dev


What this raises the problem of asset duplication. Between the raw files, the bundled files in intermediary directory in step 2, to the final collected files from collectstatic, you can have the same css, javascript, etc. duplicated in several places

This is not a large problem if all of your assets and images are not that large. Nowadays probably 50MB of static files for your website is manageable to just bundle right inside of your docker image.

So to use vite, we should add a new stage in the docker build that uses npm to create the files as described in step 2, and then we copy those to the final image before running collectstatic at runtime. We can control this with a build argument that defaults to True (will run unless we turn it off so in prod we don't have to think about it).

In development, we can use a separate image, copy just the relevant vite code over, and then run it as a webserver. The django dev container can connect to it via the docker compose network. This provides hot-module reloading.


## Setting things up

1. Install `nvm` to manage node and npm versions
    - nvm: https://github.com/nvm-sh/nvm
    - run `just setup install-nvm-on-system`
2. run the justfile command in the setup to install the pinned version of node
    - run `just setup install-node`
