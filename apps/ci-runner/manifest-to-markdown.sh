#!/bin/bash
set -euo pipefail

json_file="${1:-ci-runner-manifest.json}"

generate_markdown() {
    echo "## 🛠️ CI-Runner Tools Manifest"
    echo ""
    
    local generated_at ubuntu_version
    generated_at=$(jq -r '.generated_at' "$json_file")
    ubuntu_version=$(jq -r '.ubuntu_version' "$json_file")
    
    echo "**Generated**: ${generated_at}"
    echo ""
    echo "**Base**: ${ubuntu_version}"
    echo ""
    
    echo "<details>"
    echo "<summary><strong>📦 Runtime Versions</strong></summary>"
    echo ""
    echo "| Runtime | Version |"
    echo "|---------|---------|"
    
    jq -r '.nodejs | to_entries | .[] | "| \(.key) | `\(.value)` |"' "$json_file"
    jq -r '.python | to_entries | .[] | "| \(.key) | `\(.value)` |"' "$json_file"
    jq -r '.go | to_entries | .[] | "| go | `\(.value)` |"' "$json_file"
    jq -r '.rust | to_entries | .[] | "| rust-\(.key) | `\(.value)` |"' "$json_file"
    
    echo ""
    echo "</details>"
    echo ""
    
    echo "<details>"
    echo "<summary><strong>📦 NPM Global Packages</strong></summary>"
    echo ""
    echo "| Package | Version |"
    echo "|---------|---------|"
    jq -r '.npm_packages | to_entries | sort_by(.key) | .[] | "| \(.key) | `\(.value)` |"' "$json_file"
    echo ""
    echo "</details>"
    echo ""
    
    echo "<details>"
    echo "<summary><strong>🐳 Docker & Kubernetes</strong></summary>"
    echo ""
    echo "| Tool | Version |"
    echo "|------|---------|"
    jq -r '.binaries.docker_kubernetes | to_entries | sort_by(.key) | .[] | "| \(.key) | `\(.value)` |"' "$json_file"
    echo ""
    echo "</details>"
    echo ""
    
    echo "<details>"
    echo "<summary><strong>🗜️ Compression Tools</strong></summary>"
    echo ""
    echo "| Tool | Version |"
    echo "|------|---------|"
    jq -r '.binaries.compression | to_entries | sort_by(.key) | .[] | "| \(.key) | `\(.value)` |"' "$json_file"
    echo ""
    echo "</details>"
    echo ""
    
    echo "<details>"
    echo "<summary><strong>🔧 CLI Tools</strong></summary>"
    echo ""
    echo "| Tool | Version |"
    echo "|------|---------|"
    jq -r '.binaries.cli_tools | to_entries | sort_by(.key) | .[] | "| \(.key) | `\(.value)` |"' "$json_file"
    echo ""
    echo "</details>"
    echo ""
    
    echo "<details>"
    echo "<summary><strong>🐍 Python Tools</strong></summary>"
    echo ""
    echo "| Tool | Version |"
    echo "|------|---------|"
    jq -r '.binaries.python_tools | to_entries | sort_by(.key) | .[] | "| \(.key) | `\(.value)` |"' "$json_file"
    echo ""
    echo "</details>"
    echo ""
    
    echo "<details>"
    echo "<summary><strong>📋 APT Packages</strong></summary>"
    echo ""
    echo "| Package | Version |"
    echo "|---------|---------|"
    jq -r '.apt_packages | to_entries | sort_by(.key) | .[] | "| \(.key) | `\(.value)` |"' "$json_file"
    echo ""
    echo "</details>"
}

generate_markdown
