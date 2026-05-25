from django.contrib import messages
from django.views.decorators.http import require_POST
from django.http import HttpResponseRedirect
from django.contrib.auth.decorators import login_required
from django.urls import reverse
from django.shortcuts import render

from apps.subscriptions.utils.billing import get_stripe_module, subscription_is_acceptable
from apps.subscriptions.service import link_and_sync_subscription

from apps.subscriptions.service import create_checkout_session


@require_POST
@login_required
def create_checkout_session_view(request):
    stripe_price_id = request.POST.get("priceId")

    success_url = request.build_absolute_uri(reverse("web:subscriptions:confirm_subscription"))
    cancel_url = request.build_absolute_uri(reverse("web:home"))

    result = create_checkout_session(request.user, stripe_price_id, success_url=success_url, cancel_url=cancel_url)

    return HttpResponseRedirect(result.url)


@login_required
def confirm_subscription_view(request):

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

    return render(request, "web/users/subscription_details.html", {"msg": msg})
