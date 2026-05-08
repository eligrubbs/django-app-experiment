# Adding User Functionality + Email

Right now the site is just a single page. All websites have some sort of user capability. We are going to use several django packages to create a seamless user process.

## Users

Apparently the Django docs said I should have created users first before doing any migrations... this caused an error message in dev when using the existing local postgres database volume.

```
django.db.migrations.exceptions.InconsistentMigrationHistory: Migration admin.0001_initial is applied before its dependency users.0001_initial on database 'default'.
```

To remedy this in dev, delete the postgres database volume. To remedy this in production, delete the production database. Sorry!

Here you can see that advice on their docs: https://docs.djangoproject.com/en/6.0/ref/settings/#auth-user-model

I was able to create the migrations after updating one of the dev just recipes to run the management command to makemigrations locally, not in a docker container, so that the changes are saved to disk.

To get started make a users app in the project.

### Util Model Mix-In

Create an audit model mixin that just adds a created_at and updated_at timestamp field. This might help in the future for debugging purposes.

### Create Custom User Model

Create a custom user model that uses the audit mix-in, and the contrib.auth.models AbstractUser model. If you want add functions like `get_name`, `__str__` or something.

### Register user in admin

Not sure what to do to customize the admin page yet, so for now just register the user.

### Use `django-allauth` to handle logins

This is a batteries included package. I am choosing it to implement a password-less, otp/magic-link email-backed login flow with 3rd party OAUTH integrations for services like github or google.

To do that, add the package with the `socialaccount` add-on.

Helpful Documentation:  

- https://docs.allauth.org/en/latest/account/advanced.html#custom-user-models
    - For integrating with my custom user model
- https://docs.allauth.org/en/latest/account/adapter.html
    - For storing the email as the username

I configured allauth to use only email OTP / magic link options. I don't want to manage passwords.

### Using the admin site

Now that we have the ability to make users, we need to build the admin page.

See the admin documentation: https://docs.djangoproject.com/en/6.0/ref/contrib/admin/


## Emails - via Mailgun

At this point, in production you can check the console of the web server and log yourself in. But users should actually be able to receive emails!

To accomplish this, we will use Mailgun as our email service provider.

When creating an account, chosing to not provide payment information will enroll you in the basic plan. That is good enough, 100 emails a day is plenty for this tiny use case.

Onboarding steps:

1. Create account. Enter info. DONT add payment method so you stay on free tier. It requires a phone number as well.
2. Follow onboarding steps
    - verify email
    - create account API key (save for personal use)
    - add custom domain
    - modify the terraform in the production environment to configure mailgun as the email service
3. For each domain, create a sending key. This is what you plug into django.


Email Methodology:
1. Development Environment = Mailpit Backend
    - This keeps email sending local
2. Testing Environment = Mailpit Backend
    - Keeps email local, fast to run, easy to pull sent emails via the mailpit API.
3. Production = Mailgun Prod
    - Self explanatory. Set the right API keys as variables of course
    - We should have confidence that just swapping django configuration should work.
    - Maybe advanced use cases would have some test configured to verify email service connectivity, but we ride with manual setup then leaving it be once we think it works.
