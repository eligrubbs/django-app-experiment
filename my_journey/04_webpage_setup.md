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


## Tailwind & DaisyUI Setup

TODO
