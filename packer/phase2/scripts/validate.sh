#!/usr/bin/env bash
set -euo pipefail

echo "Validating build outputs..."

test -f ubuntu-kvm.manifest.json
test -d output/ubuntu-kvm

QCOW2_FILE="$(find output/ubuntu-kvm -type f -name '*.qcow2' | head -n 1)"

if [[ -z "${QCOW2_FILE}" ]]; then
  echo "No qcow2 file found."
  exit 1
fi

echo "Found image: ${QCOW2_FILE}"
qemu-img info "${QCOW2_FILE}"

echo "Validation complete."
