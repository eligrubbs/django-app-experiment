"""
admin command copied from `dj-stripe` package, and modified so that you can easily forward stripe webhook events
to your local database.

This command is intended to run ONLY in your development environment. It will error out if `DEBUG` is `False`.

Since stripe is going to be using this url, the host is the name of your application in the docker network.
"""

import sys
from uuid import uuid4

from django.conf import settings
from django.core.management.base import BaseCommand
from django.urls import reverse

from djstripe.enums import WebhookEndpointStatus
from djstripe.models import Account, WebhookEndpoint
from djstripe.settings import djstripe_settings


class Command(BaseCommand):
    help = "Create a Webhook Endpoint based on the passed secret and return the local endpoint to forward to"

    def add_arguments(self, parser):
        parser.add_argument(
            "secret",
            metavar="secret",
            type=str,
            help="The temporary secret from `stripe listen --print-secret` for creating a temporary webhook.",
        )
        parser.add_argument(
            "--host",
            metavar="host",
            default="web",
            type=str,
            help="The host on which Django is running INSIDE THE DOCKER COMPOSE NETWORK (defaults to web).",
        )
        parser.add_argument(
            "--port",
            metavar="port",
            default=8000,
            type=int,
            help="The port on which Django is running (defaults to 8000).",
        )

    def handle(self, *args, **options):
        host = options["host"]
        assert isinstance(host, str)
        port = options["port"]
        assert isinstance(port, int)
        secret = options["secret"]

        if not settings.DEBUG:
            self.stderr.write("This command can only be run in DEBUG mode.")
            return sys.exit(1)

        if not secret.startswith("whsec_"):
            # Not a webhook secret, print it and subsequent output
            self.stderr.write(secret)

            self.stderr.write(
                "Error: Could not get webhook secret. Make sure a proper stripe test key is set in the `.env` file."
            )

            return sys.exit(1)

        base_url = f"http://{host}:{port}"

        endpoint = WebhookEndpoint.objects.filter(id__startswith="djstripe_whfwd_", secret=secret).first()
        if not endpoint:  # only creates if it does not exist
            endpoint_uuid = uuid4()
            path = reverse("djstripe:djstripe_webhook_by_uuid", kwargs={"uuid": endpoint_uuid}).rstrip("/")
            path_suffix = f"webhook/{endpoint_uuid}"
            endpoint = WebhookEndpoint.objects.create(
                id=f"djstripe_whfwd_{endpoint_uuid.hex}",
                api_version=djstripe_settings.STRIPE_API_VERSION,
                enabled_events=["*"],
                secret=secret,
                status=WebhookEndpointStatus.enabled,
                url=base_url + path.replace(path_suffix, ""),
                djstripe_owner_account=Account.objects.first(),
                djstripe_uuid=endpoint_uuid,
                livemode=False,
            )

        # Make sure that the endpoint we give
        endpoint_url = endpoint.url + f"webhook/{endpoint.djstripe_uuid}/"

        try:
            self.stdout.write(endpoint_url)
            # subprocess.run(
            #     [
            #         STRIPE_BINARY_NAME,
            #         "listen",
            #         "--skip-update",
            #         "--forward-to",
            #         endpoint_url,
            #     ]
            # )
        except KeyboardInterrupt:
            pass
