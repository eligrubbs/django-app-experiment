# Webpage Page Setup

To serve html, css, and javascript, we leverage django's templating engine and the popular django app `whitenoise`.

## Creating the web app

following the format from [this blog](https://medium.com/@sizanmahmud08/django-folder-structure-best-practices-a-complete-guide-to-scalable-project-organization-508437899736), we will add all apps into the parent app directory (hairbrush).

Therefore, run `uv run python manage.py startapp web apps/web`

Then in the apps config, you need to change the name from `"web"` to `"apps.web"`.

Then in the `settings.py`, add `"apps.web"` to `INSTALLED_APPS`.

## Installing whitenoise

Follow the instructions on the whitenoise [documentation](https://whitenoise.readthedocs.io/en/stable/django.html) to install whitenoise

## Site Metadata / Favicon Image

### Favicons

Go to realfavicongenerator.net, upload your image (preferably svg) and follow the steps. Put the HTML template at `templates/web/components/facivon/html` and the assets in
`static/images/favicons`

### Site Metadata

I don't know what to do for this. As things become clear later, I'll figure it out then.

## Tailwind & DaisyUI Setup

I am totally disconnected from best practices, javascipt build processes, packages, etc.

To me, the simplest thing to do is to have as little javascript as possible. That means relying on HTMX, Alpine JS, and the simple tailwind css executable to manage CSS.

1. Install the standalone tailwind cli tool and edit the executable name in the `dev.just` and `ci.just` submodules.
2. Install daisyui javascript files from their [website](https://daisyui.com)

Then, the dev and ci just modules should exist to create the output.css / minified output.css file respectively.

3. Add a pre-commit hook to always minify the tailwind css on every commit.
