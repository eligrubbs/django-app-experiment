
# assumes it looks like X.X.X
PRECOMMIT_VERSION := "4.5.1"

# downloads python executable `pre-commit` to use with `python3 pre-commit`
@install-pre-commit:
    echo "hello"
    cd {{ justfile_directory() }} && curl -L -o pre-commit https://github.com/pre-commit/pre-commit/releases/download/v{{PRECOMMIT_VERSION}}/pre-commit-{{PRECOMMIT_VERSION}}.pyz
