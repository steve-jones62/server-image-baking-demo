#!/usr/bin/env bash
set -euo pipefail

echo "Applying baked baseline..."

sudo apt-get update
sudo apt-get install -y \
  qemu-guest-agent \
  cloud-init \
  curl \
  vim \
  ca-certificates

# Example banner/marker to prove the image was baked
echo "Built by Packer demo pipeline on $(date -u +%Y-%m-%dT%H:%M:%SZ)" | sudo tee /etc/demo-image-build-info

# Example: enable qemu guest agent
sudo systemctl enable qemu-guest-agent

# Clean up to keep image tidy
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
