from django.contrib.auth.models import AbstractUser

from apps.utils.models import AuditModel

from apps.subscriptions.models import SubscriptionMixin


class CustomUser(AbstractUser, AuditModel, SubscriptionMixin):
    """
    Modifying the abstract user class.
    """

    def __str__(self):
        return f"{self.get_full_name()} <{self.email or self.username}>"

    def get_display_name(self) -> str:
        if self.get_full_name().strip():
            return self.get_full_name()
        return self.email or self.username
