target "docker-metadata-action" {}

variable "APP" {
  default = "ci-runner"
}

variable "VERSION" {
  // renovate: datasource=docker depName=ubuntu
  default = "resolute-20260927"
}

variable "SOURCE" {
  default = "https://github.com/pando85/containers/tree/main/apps/${APP}"
}

variable "TRIGGERS" {
  default = "forgejo-runner"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
  }
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
  }
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
  tags = [
    "${APP}:ubuntu-${VERSION}",
    "${APP}:ubuntu-26.04"
    ]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
