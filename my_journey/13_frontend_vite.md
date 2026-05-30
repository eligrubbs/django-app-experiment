# Frontend with Vite

Setting up vite for asset management has made me think about a lot of different topics.

Basics on Vite
- https://www.saaspegasus.com/guides/modern-javascript-for-django-developers/integrating-javascript-pipeline-vite/

Guide about docker best practices and how to use django
- https://github.com/nickjj/docker-django-example


The basics is this
1. Create a directory that holds your js, css, frontend specific files
2. Specify clearly in your config what files are your entrypoint, and define clear output filenames with NO HASHES
3. Have vite target outDir to be the SAME directory that django looks in for collectstatic - this is and entry in STATICFILES_DIRS

With this format, even during development (by help of the vite server and it's quickness), the collectstatic directory will contain final assets that the webserver expects.

This greatly simplifies things in this monolithic architecture. Vite is responsible for quickly taking your code and turning it into assets for Django, Django reads STATICFILES_DIRS as if vite was not even there. The consequence of this is that you don't need any help from other tools to get hot-reloading for your django app working beyond what is already standard to use in django (django-browser-reload, django-debug-toolbar).


## Setting things up

1. Install `nvm` to manage node and npm versions
    - nvm: https://github.com/nvm-sh/nvm
    - run `just setup install-nvm-on-system`
2. run the justfile command in the setup to install the pinned version of node
    - run `just setup install-node`
3. run `npm init` to create package.json. You could also create it manually since we don't need anything except a `scripts` section
    - example
    ```
    {
        "scripts": {
            "test": "echo \"Error: no test specified\" && exit 1"
        }
    }
    ```
4. Add tailwindcss, daisyui and vite toolchain
    - `npm add -D tailwindcss vite @tailwindcss/vite daisyui`
5. Add vite config file `vite.config.js`
    - See reference [here](https://vite.dev/config/)


## Frontend workflow

A little on the philosophy we are following when it comes to modern frontend tooling.

There is currently no way to have django pass python objects directly to a javascript framework in the same way it passes context to it's template engine. Communicating between frontend and backend still necessitates an API between them... yuck! Instead, we won't use a javascript frontend and instead will use Django for template rendering. But we will leverage vite to manage frontend assets (css styles, custom javascript, etc.) which we can pull into django both in development and production.

To that end, we create an isolated directory in this repo's root called `frontend`. We will store all frontend assets here. It should be completely separated from our django project.

- `frontend/src`: Put all the raw files into here

We will set the vite build options to output specific files in the same directory that django has configured in `STATICFILES_DIRS`. With this, when vite changes those files, we instantly get rebuilds. Specifically, we will dump everything that vite manages into a `vite` subdirectory. Doing this is important for easily enabling workflows which guarantee that our frontend code and corresponding build assets always align. See the production section for why this is important.



### Development

Run in a separate terminal `just dev vite` to start the vite server which will continually build the assets as you make changes in `frontend/src` as the config file tells it to.


### Production

As mentioned above, we want to ensure that in production, our javascript / css code generates the expected outputs we saw in development. That means either setting something up to run `npm vite build` on a production setting, which requires either a docker pre-build stage that uses node, or a runtime that somehow has node and can copy the files over. Or, we can make sure during development, the very quick operation of `npm vite build` is pushed down to your machine!

To do this we have a pre-commit hook that runs `npm vite build`, and then checks to see if any unstaged changes in `/static/vite/` then appear. If so, you need to add those changes in order for your commit to pass. This allows you to add things to `/static/` without the pre-commit hooks raising any issues (as opposed to checking just `/static/` for unstaged changes in the hook).

Small hiccup, running `npm vite build` produces assets which the


## Anatomy of static directory

```
static/ # Django STATICFILE_DIRTS path
    images/ # non-vite managed image files
    vite/
        css/ # vite will dump css here
        js/ # vite will dump js here
        assets/ # non js or css assets that are bundled. Prety much won't be generated ever
```
