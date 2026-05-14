import stripe
from djstripe.models import APIKey
from djstripe.settings import djstripe_settings


def get_stripe_module():
    """Gets the Stripe API module, with the API key properly populated."""
    stripe.api_key = djstripe_settings.STRIPE_SECRET_KEY
    return stripe


def safe_create_stripe_api_keys() -> bool:
    """
    Idempotent method that tries to create djstripe APIKey objects given the STRIPE_SECRET_KEY
    that djstripe discovers from your project's settings.
    """
    _, created = APIKey.objects.get_or_create_by_api_key(djstripe_settings.STRIPE_SECRET_KEY)
    return created
