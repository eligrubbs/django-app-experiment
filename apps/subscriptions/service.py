"""
Common payment functions
"""

from djstripe.models import Subscription

from apps.subscriptions.utils.billing import get_stripe_module
from apps.users.models import CustomUser


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
