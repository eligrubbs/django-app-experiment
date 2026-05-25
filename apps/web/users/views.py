from django.shortcuts import render
from django.contrib.auth.decorators import login_required

from apps.users.service import user_details


@login_required
def profile(request):

    user_id = request.user.id

    user_obj = user_details(user_id)

    import logging

    logger = logging.getLogger()
    logger.info(f"Hello {user_obj}")

    return render(request, "web/users/profile.html", {"email": user_obj.email})
