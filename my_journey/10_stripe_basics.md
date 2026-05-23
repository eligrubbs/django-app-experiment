# Stripe Basics

The goals of the stripe integration are:

1. Be able to put users into different tiers (Free, basic, pro)
    - charge them monthly
2. Also have metered billing for some actions
    - create a fake endpoint that just "charges" them per-click.
3. Cleanly link stripe and django backend.

Create a subscriptions app in your project and install it. We will put stripe subscription stuff there.

## Create a Stripe Account

go create a stripe account. Enter your email, make a password, verify your email address, and come back when you have a sandbox environment created.

## Learn about Stripe

Follow [this tutorial](https://www.saaspegasus.com/guides/django-stripe-integrate/). It will help you learn about stripe and get started using `dj-stripe` and your stripe account.

NOTE: The `dj-stripe` package currently does not work with stripe python SDK >15. So, pin stripe to a specific version. See this [issue](https://github.com/dj-stripe/dj-stripe/issues/2221).


## Handle django-stripe API keys programatically

The `django-stripe` package has deprecated using environment variables to set your stripe API keys. You can read about it [here](https://dj-stripe.dev/docs/dev/api_keys). Well, I quite dislike that approach. Luckily, the current version still populates those in it's internal `djstripe_settings` data structure, so we can leverage those to create the databsae entries it wants.

We can create a django admin command in the subscriptions app that takes the api key we configured, and syncs the relevant stripe models from it manually on invocation.

This is just a one-time sync. If you went to the Stripe UI and updated a price, created a new product, etc., your local dev env would have no idea until you spin everything up again.

To work around this issue only in development we need the stripe-cli for dj-stripe to talk to via the stripe_listen admin command.
This is kind of complicated, but we don't actually have to set anything up on the stripe UI to get this working.

In production, we can some command to create a dj-stripe webhook endpoint (which will create one in actual stripe) in our database. Then it will us ethat.


TODO: Touch up logic for selecting price information after learning more about django query capabilities.
TODO: get local webhook set up and working
TODO: when going to production, get a live webhook flow for pre-deploy which idempotently tries to create a webhook endpoint that points to the website.

TODO: Manage Stripe Products & Prices in Terraform

TODO: When using stripe for real, make sure you change the render service module to set the prod stripe variable for the django prod parameter, not `FOR_DJANGO_STRIPE_TEST_SECRET_KEY`.


## Enabling Checkout for Users

The next step is to connect `subscriptions` and `customers` dj-stripe models to our users. We could inject this directly onto the User model, but I prefer we separate out the subscription specific logic into a mix-in.

stripe guide: https://docs.stripe.com/billing/subscriptions/build-subscriptions?ui=stripe-hosted&payment-ui=checkout&lang=python#create-session
Combined with the dj-stripe documentation.

To get things integrated, you need to add the stripe subscription / customer mix-in to your user model and run migrations. Then, use the documentation for stripe checkouts to create a checkout page that initiates a stripe checkout session. On completion of the stripe checkout, configure the success url to run a command to synchronize the customer model instance to the subscription instance, as well as implement a webhook for the checkout.complete event to perform the same action. These two functions should be idempotent, so that if one runs first, they don't ruin things.
