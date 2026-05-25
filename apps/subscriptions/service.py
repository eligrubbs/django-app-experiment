"""
Common payment functions
"""

from djstripe import models as djstripe_models
from djstripe.settings import djstripe_settings
from djstripe.models import Subscription
from stripe.checkout import Session

from apps.subscriptions.utils.billing import get_stripe_module
from apps.users.models import CustomUser


def create_checkout_session(
    user: CustomUser,
    stripe_price_id: str,
    *,
    success_url: str,
    cancel_url: str,
) -> Session:
    """
    Create a checkout session stripe object.

    TODO: utilize django sites framework so that you don't have to pass the urls to this function.
    """

    djstripe_link_metadata = {f"{djstripe_settings.SUBSCRIBER_CUSTOMER_KEY}": user.id}

    checkout_metadata = djstripe_link_metadata.copy()
    checkout_metadata.update({"source": "subscriptions"})

    subscription_metadata = djstripe_link_metadata.copy()
    subscription_metadata.update(_get_checkout_metadata(user))

    customer_kwargs = {}
    try:
        customer_kwargs["customer"] = djstripe_models.Customer.objects.get(subscriber=user).id
    except djstripe_models.Customer.DoesNotExist:
        pass
    customer_kwargs["customer_email"] = user.email

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
            "description": str(user),
            "metadata": subscription_metadata,
        },
        metadata=checkout_metadata,
        **customer_kwargs,
    )

    return result


def _get_checkout_metadata(user: CustomUser) -> dict:
    # get the id of the Model instance of djstripe_settings.djstripe_settings.get_subscriber_model()
    # here we have assumed it is the Django User model. It could be a Team, Company model too.
    # note that it needs to have an email field.
    return {
        "user_id": user.id,
        "user_email": user.email,
        "user_name": user.get_full_name(),
    }


def link_and_sync_subscription(
    subscription_holder: CustomUser,
    subscription_id: str,
):
    """
    Link a stripe subscription to the django model for the user for whom it is attached.

    Set the Customer object of the stripe subscription to the subscription
    """
    stripe = get_stripe_module()
    stripe_subscription = stripe.Subscription.retrieve(subscription_id)
    djstripe_subscription = Subscription.sync_from_stripe_data(stripe_subscription)
    subscription_holder.subscription = djstripe_subscription
    subscription_holder.save()
    # attach customer if not set
    if not subscription_holder.customer:
        subscription_holder.customer = djstripe_subscription.customer
        subscription_holder.save()
    return djstripe_subscription
