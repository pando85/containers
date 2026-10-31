# syntax=docker/dockerfile:1

# Fork revision ce5e9fc: workspace GC on top of Forgejo Runner 13.2.1.
# Pinned to the multi-platform manifest produced by pando85/runner CI:
# https://github.com/pando85/runner/actions/runs/41204013393
FROM ghcr.io/pando85/runner:sha-ce5e9fc@sha256:234a23b5536aed1641747da61c87961498d9fbc6bdbfae534f3b40336e1873a5 AS forgejo-runner

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
