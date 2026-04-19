
# assumes it looks like X.X.X
PRECOMMIT_VERSION := "4.5.1"

STATIC_DIR := justfile_directory() + "/static/js/"

@default:
    just --list setup

# downloads python executable `pre-commit` to use with `python3 pre-commit`
@install-pre-commit:
    echo "hello"
    cd {{ justfile_directory() }} && curl -L -o pre-commit https://github.com/pre-commit/pre-commit/releases/download/v{{PRECOMMIT_VERSION}}/pre-commit-{{PRECOMMIT_VERSION}}.pyz


# copies the .env.example file and creates a .env file
@env:
    echo "copying .env.example to .env"
    cd {{ justfile_directory() }} && [ ! -f .env ] && cp .env.example .env || echo ".env file already exists. please delete it first."


@add-frontend-libraries:
    # Daisy UI
    cd {{ STATIC_DIR }} && curl -sLO https://github.com/saadeghi/daisyui/releases/download/v5.5.19/daisyui.mjs
    cd {{ STATIC_DIR }} && curl -sLO https://github.com/saadeghi/daisyui/releases/download/v5.5.19/daisyui-theme.mjs

    # HTMX
    cd {{ STATIC_DIR }}  && curl -sLO https://unpkg.com/htmx.org@2.0.8/dist/htmx.min.js
    cd {{ STATIC_DIR }}  && curl -sLO https://unpkg.com/htmx-ext-response-targets@2.0.4/dist/response-targets.min.js

    # Alpine JS
    cd {{ STATIC_DIR }}  && curl -sLo alpinejs.min.js https://cdn.jsdelivr.net/npm/alpinejs@3.15.4/dist/cdn.min.js
