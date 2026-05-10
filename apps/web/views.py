from django.shortcuts import render
from django.shortcuts import redirect


def home(request):
    # TODO: Do something different
    if request.user.is_authenticated:
        return redirect("my_platform:home")
    else:
        return render(request, "web/landing_page.html")
