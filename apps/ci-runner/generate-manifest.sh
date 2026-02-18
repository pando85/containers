#!/bin/bash
set -euo pipefail

generate_manifest() {
    local ubuntu_version
    ubuntu_version=$(lsb_release -d | cut -d$'\t' -f2)
    
    local generated_at
    generated_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    echo "{"
    echo "  \"generated_at\": \"${generated_at}\","
    echo "  \"ubuntu_version\": \"${ubuntu_version}\","
    
    echo "  \"apt_packages\": {"
    
    local apt_packages=(
        "ca-certificates"
        "bzip2"
        "curl"
        "g++"
        "gcc"
        "make"
        "jq"
        "tar"
        "unzip"
        "wget"
        "autoconf"
        "automake"
        "dbus"
        "dnsutils"
        "dpkg"
        "dpkg-dev"
        "fakeroot"
        "fonts-noto-color-emoji"
        "gnupg2"
        "iproute2"
        "iputils-ping"
        "libyaml-dev"
        "libtool"
        "libssl-dev"
        "libsqlite3-dev"
        "locales"
        "mercurial"
        "openssh-client"
        "p7zip-rar"
        "pkg-config"
        "python-is-python3"
        "rpm"
        "texinfo"
        "tk"
        "tree"
        "tzdata"
        "upx"
        "xvfb"
        "xz-utils"
        "zsync"
        "acl"
        "aria2"
        "binutils"
        "bison"
        "brotli"
        "coreutils"
        "file"
        "findutils"
        "flex"
        "ftp"
        "git"
        "haveged"
        "just"
        "libnss3-tools"
        "lz4"
        "m4"
        "mediainfo"
        "net-tools"
        "netcat-openbsd"
        "p7zip-full"
        "parallel"
        "patchelf"
        "pigz"
        "pollinate"
        "ripgrep"
        "rsync"
        "shellcheck"
        "sphinxsearch"
        "sqlite3"
        "ssh"
        "sshpass"
        "sudo"
        "swig"
        "telnet"
        "time"
        "zip"
        "docker-ce"
        "docker-ce-cli"
        "python3-dev"
        "python3-pip"
        "python3-venv"
        "golang-go"
        "clang"
        "clang-format"
        "lld"
        "lldb"
        "postgresql-16"
        "libpq-dev"
        "redis-server"
        "kubectl"
    )
    
    local first=true
    for pkg in "${apt_packages[@]}"; do
        local version
        version=$(dpkg-query -W -f='${Version}' "$pkg" 2>/dev/null || echo "not_installed")
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        printf "    \"%s\": \"%s\"" "$pkg" "$version"
    done
    echo ""
    echo "  },"
    
    echo "  \"npm_packages\": {"
    local npm_packages=(
        "bun"
        "grunt"
        "gulp"
        "lerna"
        "n"
        "newman"
        "parcel"
        "pnpm"
        "typescript"
        "webpack"
        "webpack-cli"
        "yarn"
    )
    
    first=true
    for pkg in "${npm_packages[@]}"; do
        local version
        version=$(npm list -g "$pkg" --depth=0 2>/dev/null | grep "$pkg@" | sed "s/.*$pkg@//" | tr -d ' ' || echo "not_installed")
        if [ -z "$version" ]; then
            version="not_installed"
        fi
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        printf "    \"%s\": \"%s\"" "$pkg" "$version"
    done
    echo ""
    echo "  },"
    
    echo "  \"rust\": {"
    local rust_toolchain rustc_version cargo_version
    rust_toolchain=$(rustup show active-toolchain 2>/dev/null || echo "not_installed")
    rustc_version=$(rustc --version 2>/dev/null | awk '{print $2}' || echo "not_installed")
    cargo_version=$(cargo --version 2>/dev/null | awk '{print $2}' || echo "not_installed")
    echo "    \"toolchain\": \"${rust_toolchain}\","
    echo "    \"rustc\": \"${rustc_version}\","
    echo "    \"cargo\": \"${cargo_version}\""
    echo "  },"
    
    echo "  \"go\": {"
    local go_version
    go_version=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//' || echo "not_installed")
    echo "    \"version\": \"${go_version}\""
    echo "  },"
    
    echo "  \"nodejs\": {"
    local node_version npm_version
    node_version=$(node --version 2>/dev/null | sed 's/v//' || echo "not_installed")
    npm_version=$(npm --version 2>/dev/null || echo "not_installed")
    echo "    \"node\": \"${node_version}\","
    echo "    \"npm\": \"${npm_version}\""
    echo "  },"
    
    echo "  \"python\": {"
    local python_version pip_version
    python_version=$(python3 --version 2>/dev/null | awk '{print $2}' || echo "not_installed")
    pip_version=$(pip3 --version 2>/dev/null | awk '{print $2}' || echo "not_installed")
    echo "    \"python3\": \"${python_version}\","
    echo "    \"pip\": \"${pip_version}\""
    echo "  },"
    
    echo "  \"binaries\": {"
    
    local docker_buildx_version
    docker_buildx_version=$(docker buildx version 2>/dev/null | awk '{print $2}' || echo "not_installed")
    printf "    \"docker-buildx\": \"%s\"" "$docker_buildx_version"
    echo ","
    
    local docker_compose_version
    docker_compose_version=$(docker compose version 2>/dev/null | awk '{print $4}' | tr -d 'v' || echo "not_installed")
    printf "    \"docker-compose\": \"%s\"" "$docker_compose_version"
    echo ","
    
    local kind_version
    kind_version=$(kind version 2>/dev/null | awk '{print $2}' | sed 's/v//' || echo "not_installed")
    printf "    \"kind\": \"%s\"" "$kind_version"
    echo ","
    
    local kubectl_version
    kubectl_version=$(kubectl version --client --short 2>/dev/null | awk '{print $3}' | sed 's/v//' || kubectl version --client 2>/dev/null | grep -oP 'GitVersion:"v\K[^"]+' || echo "not_installed")
    printf "    \"kubectl\": \"%s\"" "$kubectl_version"
    echo ","
    
    local helm_version
    helm_version=$(helm version --short 2>/dev/null | sed 's/v//' || echo "not_installed")
    printf "    \"helm\": \"%s\"" "$helm_version"
    echo ","
    
    local minikube_version
    minikube_version=$(minikube version --short 2>/dev/null | sed 's/v//' || echo "not_installed")
    printf "    \"minikube\": \"%s\"" "$minikube_version"
    echo ","
    
    local kustomize_version
    kustomize_version=$(kustomize version --short 2>/dev/null | sed 's/v//' || echo "not_installed")
    printf "    \"kustomize\": \"%s\"" "$kustomize_version"
    echo ","
    
    local yq_version
    yq_version=$(yq --version 2>/dev/null | grep -oP 'version v\K[0-9.]+' || echo "not_installed")
    printf "    \"yq\": \"%s\"" "$yq_version"
    echo ","
    
    local zstd_version
    zstd_version=$(zstd --version 2>/dev/null | grep -oP 'v\K[0-9.]+' || echo "not_installed")
    printf "    \"zstd\": \"%s\"" "$zstd_version"
    echo ","
    
    local pipx_version
    pipx_version=$(pipx --version 2>/dev/null | awk '{print $3}' || echo "not_installed")
    printf "    \"pipx\": \"%s\"" "$pipx_version"
    
    echo ""
    echo "  }"
    echo "}"
}

generate_manifest
