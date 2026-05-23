# Frontend Refactor

After reading a lot of Django advice, I have come to the conclusion that the current project's implementation of things is pretty tightly coupled.

I want to use Django for frontend and backend, but I want the frontend to be treated as a separate part of the program, that only interfaces with the backend / business logic as if it had to play by the rules of a modern javascript webpage.

This is something I feel is necessary because working with templates scattered across different apps is causing me fatigue trying to track down what section owns what.


## Django-allauth customization

Unlike regular APIs which people design to set a clear border between their code and your orchestration of it, the styling for django-allauth templates is very opaque with context passed messily from the internal library out to the templates. This lack of a template interface (login.html will get context of type <some nested dict>) means you are left guessing how to perform non-trivial changes to individual elements.

The [documentation](https://docs.allauth.org/en/latest/common/templates.html) tells you how to style the page around the individual parts to your specifications.

I found their plain django app [example](https://codeberg.org/allauth/django-allauth/src/branch/main/examples/regular-django) to contain that piece of code I needed to help me modify the individual form fields to my liking.
