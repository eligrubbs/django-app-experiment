from djstripe.event_handlers import djstripe_receiver

from apps.subscriptions.service import link_and_sync_subscription
from apps.users.models import CustomUser


@djstripe_receiver("checkout.session.completed")
def checkout_session_completed(event, **kwargs):
    """
    This webhook is called when a customer signs up for a subscription via Stripe Checkout.

    We must then provision the subscription and assign it to the appropriate user/team.
    """
    session = event.data["object"]
    # only process subscriptions created by this module or that have a subscription set
    if session["metadata"].get("source") == "subscriptions" or session.get("subscription"):
        client_reference_id = session.get("client_reference_id")
        subscription_id = session.get("subscription")
        subscription_holder = CustomUser.objects.get(id=client_reference_id)
        link_and_sync_subscription(subscription_holder, subscription_id)
