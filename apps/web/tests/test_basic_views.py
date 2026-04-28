from django.urls import reverse

from .base import TestViewBase


class TestBasicViews(TestViewBase):
    def _assert_200(self, url):
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)

    def test_landing_page(self):
        self._assert_200(reverse("web:home"))

    def test_health(self):
        self._assert_200(reverse("web:health_check"))
