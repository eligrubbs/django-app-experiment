# Django Hello World w/ Local CI Stuff

## Python / Django Setup

### uv setup

Begin by installing `uv` to your machine. Google it, figure it out.

Then, in the main directory of this project, run `uv init`.

Delete the main.py file

run `uv add Django`.

### Django setup

Looking at the posthog github repository, they set up their project as such:

1. manage.py is in the global directory
2. the entire django app is contained in at `<parent directory>/posthog`


To that end, in the base directory, run `uv run django-admin startproject hairbrush .`.

### Verify setup

run `uv run python manage.py runserver` to start the development server.

The `manage.py` is a python script, so you have to run a python interpreter that points to the uv venv you just made.

If you activate the environment first, you can run `python manage.py runserver`.

## Local CI Steps

This step installs some packages that we use to bring consistency to code and the repo.

### `Just` for easier scripts

Instead of popular tools like Make or such, we use `just` to manage scripts and simple utility functions.

That is not to say we won't ever use plain bash scripts, we might too!

The command runner `just` should be installed onto your machine.
- Recommeneded to [install a pre-built binary](https://github.com/casey/just?tab=readme-ov-file#pre-built-binaries) onto your machine.

### Pre-commit hooks

Pre-commit hooks ensure consistency throughout the entire project. To manage these the `pre-commit` python
library is used. But, since this is a kind of global tool, you will install an isolated binary to this projects directory.
- find more about `pre-commit` [here](https://pre-commit.com/). Add `pre-commit` to the git ignore file

Since you've installed `just`, and you have a global python version managed by `uv`, you can use the convenience script
to install the pre-commit 0-dependency py-zip file. Then you can run `python3 pre-commit`.

To install the pre-commit hooks, run from the project root directory

```
chmod +x pre-commit
./pre-commit install
```
