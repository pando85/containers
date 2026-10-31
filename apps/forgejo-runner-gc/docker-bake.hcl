target "docker-metadata-action" {}

variable "APP" {
  default = "forgejo-runner-gc"
}

variable "VERSION" {
  // Fork revision ce5e9fc includes workspace GC; based on upstream Forgejo Runner 13.2.1.
  // Update this value and the pinned source digest together when upgrading the fork.
  default = "13.2.1"
}

variable "SOURCE" {
  default = "https://github.com/pando85/runner"
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
