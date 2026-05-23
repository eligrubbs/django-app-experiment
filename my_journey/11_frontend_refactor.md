# Frontend Refactor

After reading a lot of Django advice, I have come to the conclusion that the current project's implementation of things is pretty tightly coupled.

I want to use Django for frontend and backend, but I want the frontend to be treated as a separate part of the program, that only interfaces with the backend / business logic as if it had to play by the rules of a modern javascript webpage.

This is something I feel is necessary because working with templates scattered across different apps is causing me fatigue trying to track down what section owns what.
