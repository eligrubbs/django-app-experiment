from django.shortcuts import render


def home(request):
    # TODO: Do something different
    if request.user.is_authenticated:
        return render(request, "web/landing_page.html")
    else:
        return render(request, "web/landing_page.html")
