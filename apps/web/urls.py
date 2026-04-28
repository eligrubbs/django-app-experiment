from django.conf import settings
from django.urls import path
from health_check.views import HealthCheckView

from . import views


app_name = "web"
urlpatterns = [
    path("", views.home, name="home"),
    path(
        f"health/{settings.HEALTH_CHECK_SECRET}",
        HealthCheckView.as_view(
            checks=[
                "health_check.Database",
            ]
        ),
        name="health_check",
    ),
]
