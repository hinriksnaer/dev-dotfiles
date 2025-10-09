#!/usr/bin/env bash
set -euo pipefail

echo "→ Init & update submodules"
git submodule sync --recursive
git submodule update --init --recursive

echo "→ Installing stow"

# Packages to install
packages=(
  stow
)

sudo dnf upgrade --refresh -y
sudo dnf install -y "${packages[@]}"


