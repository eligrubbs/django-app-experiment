from django.http import HttpRequest
from django.conf import settings


def web_meta(request: HttpRequest):
    # adds these variables to be available in templates
    return {
        "web": {
            "light_theme": settings.LIGHT_THEME,
            "dark_theme": settings.DARK_THEME,
            "current_theme": request.COOKIES.get("theme", ""),
            "dark_mode": request.COOKIES.get("theme", "") == settings.DARK_THEME,
        }
    }
