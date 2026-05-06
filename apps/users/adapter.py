from allauth.account import app_settings
from allauth.account.adapter import DefaultAccountAdapter
from allauth.account.utils import user_email, user_field


class EmailAsUsernameAdapter(DefaultAccountAdapter):
    """
    Adapter that always sets the username equal to the user's email address.

    https://docs.allauth.org/en/latest/account/adapter.html#allauth.account.adapter.DefaultAccountAdapter
    """

    def __init__(self, request=None):
        super().__init__(request)
        self.error_messages["email_taken"] = "There was a problem creating the account. Please contact support."

    def populate_username(self, request, user):
        user_field(user, app_settings.USER_MODEL_USERNAME_FIELD, user_email(user))


class NoNewUsersAccountAdapter(DefaultAccountAdapter):
    """
    Adapter that can be used to disable public sign-ups for the app.

    https://stackoverflow.com/a/29799664/8207
    """

    def is_open_for_signup(self, request):
        return False
