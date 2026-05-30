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
3. run `npm init` to create package.json. But we don't need anything except a `scripts` section
    - example
    ```
    {
        "scripts": {
            "test": "echo \"Error: no test specified\" && exit 1"
        }
    }
    ```
4. Add tailwindcss, and vite toolchain
    - `npm add -D tailwindcss vite @tailwindcss/vite`
5. Add vite config file `vite.config.js`
    - See reference [here](https://vite.dev/config/)


## Frontend workflow

A little on the philosophy we are following when it comes to modern frontend tooling.

There is currently no way to have django pass python objects directly to a javascript framework in the same way it passes context to it's template engine. Communicating between frontend and backend still necessitates an API between them... yuck! Instead, we won't use a javascript frontend and instead will use Django for template rendering. But we will leverage vite to manage frontend assets (css styles, custom javascript, etc.) which we can pull into django both in development and production.

To that end, we create an isolated directory in this repo's root called `frontend`. We will store all frontend assets here. It should be completely separated from our django project.

- `frontend/src`: Put all the raw files into here

We will set the vite build options to output specific files in the same directory that django has configured in `STATICFILES_DIRS`. With this, when vite changes those files, we instantly get rebuilds.

## Integrating with Django

In short:

- The django plugin `django-vite` will be used as switches seemlessly between dev & prod

- Dev Env: We will use vite to run as a server. The `django-vite` plugin will link the server with django right on top of your raw files, that way you can change them they hot-reload
- Prod Env: We will use a docker pre-build stage to compile the files, then in the final stage copy those files to the directory we expect them to live in.


## Anatomy of static directory

```
static/ # Django STATICFILE_DIRTS path
    css/ # vite will dump css here
    js/ # vite will dump js here
    images/ # non-vite managed image files
    assets/ # non js or css assets that are bundled. Prety much won't be generated ever
```
