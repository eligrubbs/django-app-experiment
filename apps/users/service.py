from apps.users.models import CustomUser


def user_details(user_id):
    _user = CustomUser.objects.get(id=user_id)
    return _user
