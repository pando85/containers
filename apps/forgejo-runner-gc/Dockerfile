# syntax=docker/dockerfile:1

# The runner fork's main branch publishes :edge after passing Go tests and
# multi-architecture builds. Renovate proposes digest updates for review.
# Verified source build: https://github.com/pando85/runner/actions/runs/41213285659
FROM ghcr.io/pando85/runner:edge@sha256:9b038cc4617ece507f6097eb78d93af4b09b07ee116567a6e68a42d0f0cad31a AS forgejo-runner

FROM ghcr.io/pando85/ci-runner:rolling@sha256:ed6a725c587ca668dfecc3280eefaebd9e536549b011c0defa9edd6d49c07525

RUN adduser --disabled-password --gecos "" --uid 1001 runner \
    && usermod -aG sudo runner \
    && usermod -aG docker runner \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers \
    && chmod 777 /home/runner

WORKDIR /home/runner

COPY --chown=runner:docker --from=forgejo-runner /bin/forgejo-runner /bin/forgejo-runner

USER runner
