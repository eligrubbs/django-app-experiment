from django.urls import path

from . import views


app_name = "my_platform"
urlpatterns = [
    path("", views.platform, name="home"),
]
