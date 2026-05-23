from django.contrib import messages
from django.views.decorators.http import require_POST
from django.http import HttpResponseRedirect
from django.contrib.auth.decorators import login_required
from django.urls import reverse
from django.shortcuts import render
from djstripe import models as djstripe_models
from djstripe.settings import djstripe_settings

from apps.users.models import CustomUser
from apps.subscriptions.utils.billing import get_stripe_module, subscription_is_acceptable
from apps.subscriptions.service import link_and_sync_subscription


@require_POST
@login_required
def create_checkout_session(request):
    stripe_price_id = request.POST.get("priceId")

    success_url = request.build_absolute_uri(reverse("subscriptions:confirm_subscription"))
    cancel_url = request.build_absolute_uri(reverse("web:home"))

    djstripe_link_metadata = {f"{djstripe_settings.SUBSCRIBER_CUSTOMER_KEY}": request.user.id}

    checkout_metadata = djstripe_link_metadata.copy()
    checkout_metadata.update({"source": "subscriptions"})

    subscription_metadata = djstripe_link_metadata.copy()
    subscription_metadata.update(_get_checkout_metadata(request.user))

    customer_kwargs = {}
    try:
        customer_kwargs["customer"] = djstripe_models.Customer.objects.get(subscriber=request.user).id
    except djstripe_models.Customer.DoesNotExist:
        pass
    customer_kwargs["customer_email"] = request.user.email

    stripe = get_stripe_module()

    result = stripe.checkout.Session.create(
        payment_method_types=["card"],
        mode="subscription",
        line_items=[
            {
                "price": stripe_price_id,
                "quantity": 1,
            },
        ],
        # Adding CHECKOUT_SESSION_ID https://docs.stripe.com/payments/checkout/custom-success-page?payment-ui=stripe-hosted#modify-the-success-url
        success_url=success_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url=cancel_url,
        subscription_data={
            "description": str(request.user),
            "metadata": subscription_metadata,
        },
        metadata=checkout_metadata,
        **customer_kwargs,
    )

    return HttpResponseRedirect(result.url)


def _get_checkout_metadata(user: CustomUser) -> dict:
    # get the id of the Model instance of djstripe_settings.djstripe_settings.get_subscriber_model()
    # here we have assumed it is the Django User model. It could be a Team, Company model too.
    # note that it needs to have an email field.
    return {
        "user_id": user.id,
        "user_email": user.email,
        "user_name": user.get_full_name(),
    }


@login_required
def confirm_subscription(request):

    session_id = request.GET.get("session_id")
    if not session_id:
        messages.error(request, "No Stripe Session ID Found.")
        return HttpResponseRedirect(request.build_absolute_uri(reverse("web:home")))

    stripe = get_stripe_module()
    session = stripe.checkout.Session.retrieve(session_id)
    status = session.payment_status
    if status != "paid":
        messages.error(request, "Subscription Session is not in `paid` status.")
        return HttpResponseRedirect(request.build_absolute_uri(reverse("web:home")))

    # create subscription link in djstripe
    subscription_holder = request.user
    if not subscription_holder.subscription or subscription_holder.subscription_id != session.subscription:
        djstripe_subscription = link_and_sync_subscription(
            subscription_holder=subscription_holder, subscription_id=session.subscription
        )
    else:
        # already created
        djstripe_subscription = subscription_holder.subscription
    messages.success(
        request,
        f"You've signed up for {djstripe_subscription.items.select_related('price__product')[0].price.product.name}.",
    )

    return HttpResponseRedirect(request.build_absolute_uri(reverse("web:users:profile")))


@login_required
def subscription_details(request):
    subscription_holder = request.user
    if subscription_is_acceptable(subscription_holder.subscription):
        msg = "You Have a Subscription"
    else:
        msg = "You do not have a subscription"

    return render(request, "users/subscription_details.html", {"msg": msg})
