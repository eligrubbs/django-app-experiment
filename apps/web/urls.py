from django.conf import settings
from django.urls import path, include
from health_check.views import HealthCheckView

from . import views


app_name = "web"
urlpatterns = [
    path("", views.home, name="home"),
    path("pricing/", views.pricing, name="pricing"),
    path(
        f"health/{settings.HEALTH_CHECK_SECRET}",
        HealthCheckView.as_view(
            checks=[
                "health_check.Database",
            ]
        ),
        name="health_check",
    ),
    path("users/", include("apps.web.users.urls")),
]
