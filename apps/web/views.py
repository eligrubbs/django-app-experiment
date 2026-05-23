from django.contrib import messages
from django.shortcuts import render
from django.shortcuts import redirect
from django.db.models import Prefetch

from djstripe.models import Product, Price


def home(request):
    # TODO: Do something different
    if request.user.is_authenticated:
        return redirect("my_platform:home")

    send_test_msg = request.GET.get("send_msg")
    import logging

    logger = logging.getLogger()
    logger.info(f"Hello from homepage {send_test_msg}")
    if send_test_msg is not None:
        messages.success(request, "Test Message")
    return render(request, "web/landing_page.html")


def pricing(request):

    import logging

    logger = logging.getLogger(__name__)
    _set = Product.objects.prefetch_related(Prefetch("prices", queryset=Price.objects.all(), to_attr="the_prices"))
    logger.info(_set)
    logger.info(_set[0].prices)

    def model_to_dict(instance):
        return {field.name: getattr(instance, field.name) for field in instance._meta.fields}

    data = []

    for parent in _set:
        parent_dict = model_to_dict(parent)

        parent_dict["children"] = [model_to_dict(child) for child in parent.the_prices]

        logger.info(f"{parent_dict['name'], parent_dict['active']}")
        for childs in parent_dict["children"]:
            logger.info(childs["stripe_data"]["unit_amount"])

        data.append(parent_dict)

    data.sort(key=lambda x: x["children"][0]["stripe_data"]["unit_amount"])

    logger.info(data[0]["children"])
    return render(request, "web/pricing_page.html", {"products": data})
