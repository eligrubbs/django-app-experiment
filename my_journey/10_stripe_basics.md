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

In production, we can some command to create a dj-stripe webhook endpoint (which will create one in actual stripe) in our database. Then it will us ethat.


TODO: Touch up logic for selecting price information after learning more about django query capabilities.
