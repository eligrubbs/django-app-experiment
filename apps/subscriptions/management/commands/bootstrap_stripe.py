from django.core.management import call_command
from django.core.management.base import BaseCommand
from djstripe.models import Account
from stripe import AuthenticationError

from apps.subscriptions.utils.billing import safe_create_stripe_api_keys, get_stripe_module


class Command(BaseCommand):
    help = "Bootstraps your Stripe subscriptions"

    def handle(self, **options):
        self.stdout.write("Syncing products and prices from Stripe")
        try:
            if safe_create_stripe_api_keys():
                self.stdout.write("Added Stripe secret key to the database...")
            # dj-stripe 2.10+ requires a synced Account (djstripe_owner_account FK).
            # Sync it first so that product/price sync can link to it.
            self._ensure_account_synced()
            # due to an issue in djstripe sometimes failing on unsynced data,
            # we need to sync prices once before syncing both products and prices
            call_command("djstripe_sync_models", "price")
            call_command("djstripe_sync_models", "product", "price")
        except AuthenticationError:
            self.stderr.write(
                "\n======== ERROR ==========\n"
                "Failed to authenticate with Stripe! Check your Stripe key settings.\n"
                "More info: https://dj-stripe.dev/docs/dev/api_keys"
            )
        return

    def _ensure_account_synced(self):
        """Ensure the Stripe Account exists in the dj-stripe DB.

        dj-stripe 2.10+ links every object to djstripe_owner_account.
        Without it, all sync operations skip with 'Account matching query does not exist'.
        """
        if Account.objects.exists():
            return
        self.stdout.write("No Stripe Account in DB — syncing from Stripe API...")
        stripe = get_stripe_module()
        stripe_account = stripe.Account.retrieve()
        Account.sync_from_stripe_data(stripe_account)
        self.stdout.write(f"Synced Account {stripe_account.id}")
