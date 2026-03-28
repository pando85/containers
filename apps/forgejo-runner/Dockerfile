# syntax=docker/dockerfile:1

ARG VERSION
FROM code.forgejo.org/forgejo/runner:${VERSION} AS forgejo-runner

FROM ghcr.io/pando85/ci-runner:rolling@sha256:f217a814a12cebd5656534d9254bf60bf4aba6d8aa8845f4796332f3f7b98f8f
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
