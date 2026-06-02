# syntax=docker/dockerfile:1

ARG VERSION
FROM code.forgejo.org/forgejo/runner:${VERSION} AS forgejo-runner

FROM ghcr.io/pando85/ci-runner:rolling@sha256:b0745f1d24b6dcc935abbd337d821cc4bc31e3f68a8f78da0ddac28e0f22b406
ARG TARGETARCH

RUN adduser --disabled-password --gecos "" --uid 1001 runner \
    && usermod -aG sudo runner \
    && usermod -aG docker runner \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers \
    && chmod 777 /home/runner

WORKDIR /home/runner

COPY --chown=runner:docker --from=forgejo-runner /bin/forgejo-runner /bin/forgejo-runner

USER runner
