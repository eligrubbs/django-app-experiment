from django.urls import path

from . import views


app_name = "subscriptions"
urlpatterns = [
    path("", views.subscription_details, name="subscription_details"),
    path("create_checkout_session", views.create_checkout_session, name="create_checkout_session"),
    path("confirm_subscription", views.confirm_subscription, name="confirm_subscription"),
]
