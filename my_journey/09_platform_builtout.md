# Building The Platform

Right now we have a landing page. This landing page displays that we are logged in.

Instead we want to build out the very basics of our platform. The platform will consist of:

1. A page at `/platform` that just says "welcome to the platform!".
    - Should have a navbar to the user profile
    - should be navigated to this page if the user is logged in.
2. A user profile page
    - Should have a navbar
    - should be able to log out
    - should be connected to the allauth pages


### Configuring Allauth Templates

See there guide [here](https://docs.allauth.org/en/dev/common/templates.html).

I found it very difficult to try and change the allauth templates flexibly without having to gut everything and create my own templates. In the future, when you have a requirement to fully customize the allauth layout / flow, roll your own templates. This is possible by spending time looking into the source code of the default templates, and reverse-engineering what forms point to what views and so forth.

To roll your own allauth UI, you should:
1. Identify which all-auth routes / links you actually need.
    - Then in the urls of your app set explicit 404 routes for each NOT needed
    - or just selectively add the ones you want and point them to the right allauth views
2. Create your templates and hook them up to the right views
