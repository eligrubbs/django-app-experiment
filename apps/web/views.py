from django.shortcuts import render
from django.shortcuts import redirect
from django.db.models import Prefetch

from djstripe.models import Product, Price

# from apps.subscriptions.metadata import get_active_products_with_metadata


def home(request):
    # TODO: Do something different
    if request.user.is_authenticated:
        return redirect("my_platform:home")
    else:
        return render(request, "web/landing_page.html")


def pricing(request):
    if request.user.is_authenticated:
        return redirect("my_platform:home")
    else:
        import logging

        logger = logging.getLogger(__name__)
        # items = [x for x in get_active_products_with_metadata()]
        # logger.info(items)
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

        logger.info(data[0]["children"])
        return render(request, "web/pricing_page.html", {"products": data})
