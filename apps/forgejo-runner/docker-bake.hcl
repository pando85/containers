target "docker-metadata-action" {}

variable "APP" {
  default = "forgejo-runner"
}

variable "VERSION" {
  // renovate: datasource=docker depName=code.forgejo.org/forgejo/runner
  default = "12.5.3"
}

variable "SOURCE" {
  default = "https://github.com/pando85/containers/tree/main/apps/${APP}"
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
  tags = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
