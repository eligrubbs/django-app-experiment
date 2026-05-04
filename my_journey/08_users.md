# Adding User Functionality

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
