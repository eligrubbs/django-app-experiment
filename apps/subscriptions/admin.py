"""
Custom admin configuration for dj-stripe Customer model.

In dj-stripe 2.10, the default Customer admin is currently broken,
see https://github.com/dj-stripe/dj-stripe/issues/2189
"""

from django.contrib import admin

from djstripe.models import Customer
from unfold.admin import ModelAdmin

admin.site.unregister(Customer)


@admin.register(Customer)
class CustomerAdmin(ModelAdmin):
    """
    Minimal Customer admin using only database fields.
    """

    pass
