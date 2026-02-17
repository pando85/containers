# syntax=docker/dockerfile:1

ARG VERSION
FROM ubuntu:${VERSION}
ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        lsb-release \
    && rm -rf /var/lib/apt/lists/*

# vital packages
RUN apt-get update \
    && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        bzip2 \
        curl \
        g++ \
        gcc \
        make \
        jq \
        tar \
        unzip \
        wget \
    && rm -rf /var/lib/apt/lists/*

# common packages
RUN apt-get update \
    && \
    apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        dbus \
        dnsutils \
        dpkg \
        dpkg-dev \
        fakeroot \
        fonts-noto-color-emoji \
        gnupg2 \
        iproute2 \
        iputils-ping \
        libyaml-dev \
        libtool \
        libssl-dev \
        libsqlite3-dev \
        locales \
        mercurial \
        openssh-client \
        p7zip-rar \
        pkg-config \
        python-is-python3 \
        rpm \
        texinfo \
        tk \
        tree \
        tzdata \
        upx \
        xvfb \
        xz-utils \
        zsync \
    && rm -rf /var/lib/apt/lists/*

# cmd packages
RUN apt-get update \
    && \
    apt-get install -y --no-install-recommends \
        acl \
        aria2 \
        binutils \
        bison \
        brotli \
        coreutils \
        file \
        findutils \
        flex \
        ftp \
        git \
        haveged \
        just \
        libnss3-tools \
        lz4 \
        m4 \
        mediainfo \
        net-tools \
        netcat-openbsd \
        p7zip-full \
        parallel \
        patchelf \
        pigz \
        pollinate \
        ripgrep \
        rsync \
        shellcheck \
        sphinxsearch \
        sqlite3 \
        ssh \
        sshpass \
        sudo \
        swig \
        telnet \
        time \
        zip \
    && rm -rf /var/lib/apt/lists/*

# docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo \
        "deb [arch=${TARGETARCH} signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        docker-ce \
        docker-ce-cli \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -pv /usr/libexec/docker/cli-plugins \
    && buildx_url=$(curl -fsSL https://api.github.com/repos/docker/buildx/releases/latest | grep "browser_download_url.*linux.*.${TARGETARCH}\"" | cut -d : -f 2,3 | tr -d \") \
    && curl -fsSL ${buildx_url} -o /usr/libexec/docker/cli-plugins/docker-buildx \
    && chmod +x /usr/libexec/docker/cli-plugins/docker-buildx \
    && arch=$([ "$TARGETARCH" = "amd64" ] && echo "x86_64" || ([ "$TARGETARCH" = "arm64" ] && echo "aarch64" || echo "$TARGETARCH")) \
    && curl -fsSL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-${arch} -o /usr/libexec/docker/cli-plugins/docker-compose \
    && chmod +x /usr/libexec/docker/cli-plugins/docker-compose

# python and pipx setup
ENV PIPX_BIN_DIR=/opt/pipx_bin
ENV PIPX_HOME=/opt/pipx
ENV PATH="${PIPX_BIN_DIR}:${PATH}"

RUN apt-get update \
    && \
    apt-get install -y --no-install-recommends \
        python3-dev \
        python3-pip \
        python3-venv \
    && rm -rf /var/lib/apt/lists/* \
    && echo '[global]' > /etc/pip.conf \
    && echo 'break-system-packages = true' >> /etc/pip.conf \
    && python3 -m pip install pipx \
    && python3 -m pipx ensurepath

# rust setup
ENV RUSTUP_HOME=/usr/share/rust/.rustup
ENV CARGO_HOME=/usr/share/rust/.cargo
ENV PATH="$CARGO_HOME/bin:$PATH"

RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y --default-toolchain=stable --profile=minimal \
    && . $CARGO_HOME/env \
    && rustup component add rustfmt clippy \
    && rm -rf ${CARGO_HOME}/registry/* \
    && chmod -R 777 "$(dirname "${RUSTUP_HOME}")"

# nodejs setup
RUN curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n -o /tmp/n \
    && bash /tmp/n lts \
    && npm install -g \
        bun \
        grunt \
        gulp \
        lerna \
        n \
        newman \
        parcel \
        pnpm \
        typescript \
        webpack \
        webpack-cli \
        yarn \
    && ln -s /usr/local/bin/vercel /usr/local/bin/now \
    && chmod -R 777 /usr/local/lib/node_modules \
    && chmod -R 777 /usr/local/bin \
    && rm -rf /tmp/n

# go setup
RUN curl -fsSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x876b22ba887ca91614b5323fc631127f87fa12d1' \
        | gpg --dearmor -o /usr/share/keyrings/golang-backports-keyring.gpg \
    && echo \
        "deb [arch=${TARGETARCH} signed-by=/usr/share/keyrings/golang-backports-keyring.gpg] http://ppa.launchpad.net/longsleep/golang-backports/ubuntu \
        $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/golang-backports.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends golang-go \
    && rm -rf /var/lib/apt/lists/*

# clang setup
RUN apt-get update \
    && \
    apt-get install -y --no-install-recommends \
        clang \
        clang-format \
        lld \
        lldb \
    && rm -rf /var/lib/apt/lists/*

# k8s tools setup
RUN \
    # Install KIND
    curl -fsSL https://github.com/kubernetes-sigs/kind/releases/latest/download/kind-linux-${TARGETARCH} -o /usr/local/bin/kind \
    && chmod +x /usr/local/bin/kind \
    && \
    # Install kubectl
    mkdir -p /etc/apt/keyrings \
    && kubectl_minor_version=$(curl -fsSL https://dl.k8s.io/release/stable.txt | cut -d'.' -f1,2) \
    && curl -fsSL https://pkgs.k8s.io/core:/stable:/$kubectl_minor_version/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg arch=${TARGETARCH}] https://pkgs.k8s.io/core:/stable:/$kubectl_minor_version/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubectl \
    && \
    # Install Helm
    curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
    && \
    # Install minikube
    curl -fsSL https://storage.googleapis.com/minikube/releases/latest/minikube-linux-${TARGETARCH} -o /usr/local/bin/minikube \
    && chmod +x /usr/local/bin/minikube \
    && \
    # Install kustomize
    curl -fsSL https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh | bash \
    && mv kustomize /usr/local/bin

# postgres setup
RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > /usr/share/keyrings/postgresql.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] https://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get install -y postgresql-16 libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# redis setup
RUN curl -fsSL https://packages.redis.io/gpg | gpg --dearmor > /usr/share/keyrings/redis-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" > /etc/apt/sources.list.d/redis.list \
    && apt-get update \
    && apt-get install -y redis-server \
    && rm -rf /var/lib/apt/lists/*

# yq setup
RUN curl -fsSL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${TARGETARCH} -o /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

# zstd setup
RUN apt-get update \
    && apt-get install -y --no-install-recommends liblz4-dev \
    && rm -rf /var/lib/apt/lists/* \
    && set -eux; \
    release_tag=$(curl -fsSL https://api.github.com/repos/facebook/zstd/releases/latest | jq -r '.tag_name'); \
    release_name="zstd-${release_tag#v}"; \
    download_url="https://github.com/facebook/zstd/releases/download/${release_tag}/${release_name}.tar.gz"; \
    archive="/tmp/${release_name}.tar.gz"; \
    checksum_url="${download_url}.sha256"; \
    curl -fsSL -o "${archive}" "${download_url}"; \
    curl -fsSL -o "/tmp/${release_name}.tar.gz.sha256" "${checksum_url}"; \
    expected=$(grep -Eo '^[a-f0-9]{64}' "/tmp/${release_name}.tar.gz.sha256" | head -n1); \
    if [ -z "$expected" ]; then echo "zstd checksum not found" >&2; exit 1; fi; \
    echo "${expected}  ${archive}" > /tmp/checksum.txt; \
    sha256sum -c /tmp/checksum.txt; \
    tar xzf "${archive}" -C /tmp; \
    make -C "/tmp/${release_name}/contrib/pzstd" -j"$(nproc)" all; \
    make -C "/tmp/${release_name}" -j"$(nproc)" zstd-release; \
    cp "/tmp/${release_name}/programs/zstd" /usr/local/bin/; \
    cp "/tmp/${release_name}/programs/zstdless" /usr/local/bin/; \
    cp "/tmp/${release_name}/programs/zstdgrep" /usr/local/bin/; \
    cp "/tmp/${release_name}/contrib/pzstd/pzstd" /usr/local/bin/; \
    chmod +x /usr/local/bin/zstd* /usr/local/bin/pzstd || true; \
    ln -sf /usr/local/bin/zstd /usr/local/bin/zstdcat; \
    ln -sf /usr/local/bin/zstd /usr/local/bin/zstdmt; \
    ln -sf /usr/local/bin/zstd /usr/local/bin/unzstd; \
    rm -rf "/tmp/${release_name}" "${archive}" /tmp/${release_name}.tar.gz.sha256 /tmp/checksum.txt
