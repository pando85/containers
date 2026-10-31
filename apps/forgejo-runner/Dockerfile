# syntax=docker/dockerfile:1

ARG VERSION
FROM code.forgejo.org/forgejo/runner:${VERSION} AS forgejo-runner

FROM ghcr.io/pando85/ci-runner:rolling@sha256:ed6a725c587ca668dfecc3280eefaebd9e536549b011c0defa9edd6d49c07525
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
