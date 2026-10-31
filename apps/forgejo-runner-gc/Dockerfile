# syntax=docker/dockerfile:1

# The runner fork's main branch publishes :edge after passing Go tests and
# multi-architecture builds. Renovate proposes digest updates for review.
# Verified source build: https://github.com/pando85/runner/actions/runs/41213285659
FROM ghcr.io/pando85/runner:edge@sha256:b7c75fcf09f25364bc6a804b7f06d8bbddbc5a61f05f89c8537a98e38fcf91b4 AS forgejo-runner

FROM ghcr.io/pando85/ci-runner:rolling@sha256:70cac4d97bc7220c162bd869867e2f953c6bb1b201536a5a45244def066235da

RUN adduser --disabled-password --gecos "" --uid 1001 runner \
    && usermod -aG sudo runner \
    && usermod -aG docker runner \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers \
    && chmod 777 /home/runner

WORKDIR /home/runner

COPY --chown=runner:docker --from=forgejo-runner /bin/forgejo-runner /bin/forgejo-runner

USER runner
