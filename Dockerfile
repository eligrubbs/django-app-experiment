# Don't actually change this from /app. Many things outside the docker container depend on this being `/app`.
# But, having it as an arg makes for a cleaner dockerfile
ARG APP_DIR="/app"

ARG VERSION_OF_UV="0.11.7"
ARG PYTHON_VERSION="3.14"
ARG MY_UID="4323"
ARG MY_GID="4323"

# Stage 0: define state using variable as workaround to have parameterized uv arg
FROM ghcr.io/astral-sh/uv:${VERSION_OF_UV} AS uv_executables

# Stage 1: Builder
FROM debian:bookworm-slim AS builder
ARG APP_DIR PYTHON_VERSION VERSION_OF_UV

COPY --from=uv_executables /uv /uvx /bin/

WORKDIR ${APP_DIR}

ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy UV_PYTHON_INSTALL_DIR=${APP_DIR}/python UV_PYTHON_PREFERENCE=only-managed

# Install Python before the project for caching
RUN uv python install ${PYTHON_VERSION}

# Install dependencies which do not change often
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project --no-editable --no-dev
COPY . ${APP_DIR}/
# Install actual package in editable mode
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-dev



# Stage 2: Final lightweight image
FROM debian:bookworm-slim
ARG APP_DIR MY_UID MY_GID NON_ROOT_USER=runner

# Create a non-root user to run things
# alpine version
# RUN addgroup -g 4323 -S ${NON_ROOT_USER} && adduser -u 4323 -S ${NON_ROOT_USER} -G ${NON_ROOT_USER}
# Debian version
# Home directory created for user so other dependencies can automatically put files there
RUN groupadd --gid ${MY_GID} ${NON_ROOT_USER} && useradd --uid ${MY_UID} --gid ${MY_GID} --create-home ${NON_ROOT_USER}

USER ${NON_ROOT_USER}

COPY --from=builder --chown=${NON_ROOT_USER}:${NON_ROOT_USER} ${APP_DIR}/ ${APP_DIR}/

ENV PATH="${APP_DIR}/.venv/bin:$PATH"

WORKDIR ${APP_DIR}
