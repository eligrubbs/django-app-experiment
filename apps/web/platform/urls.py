from django.urls import path

from . import views


app_name = "platform"
urlpatterns = [
    path("", views.platform, name="home"),
]
