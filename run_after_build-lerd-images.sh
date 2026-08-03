#!/bin/sh

set -eu

if ! command -v podman >/dev/null 2>&1; then
  echo "Podman is unavailable; skipping Lerd image provisioning."
  exit 0
fi

lerd_image_root="$HOME/.config/lerd/images"
[ -d "$lerd_image_root" ] || exit 0

file_checksum() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{ print $1 }'
  else
    shasum -a 256 "$1" | awk '{ print $1 }'
  fi
}

build_lerd_image() {
  image_name=$1
  containerfile=$2
  checksum=$(file_checksum "$containerfile")
  current_checksum=$(podman image inspect \
    --format '{{ index .Labels "dev.lerd.containerfile-sha" }}' \
    "$image_name" 2>/dev/null || true)

  if [ "$current_checksum" = "$checksum" ]; then
    echo "$image_name is up to date."
    return 0
  fi

  echo "Building $image_name..."
  podman build \
    --label "dev.lerd.containerfile-sha=$checksum" \
    --tag "$image_name" \
    --file "$containerfile" \
    "$lerd_image_root"
}

build_lerd_image \
  localhost/lerd-postgres16-postgis-pgvector:local \
  "$lerd_image_root/postgres16-postgis-pgvector.Containerfile"
build_lerd_image \
  localhost/lerd-postgres18-postgis-pgvector:local \
  "$lerd_image_root/postgres18-postgis-pgvector.Containerfile"
