#!/bin/sh

set -eu

MEETILY_VERSION="0.4.0"
MEETILY_REPOSITORY="https://github.com/Zackriya-Solutions/meetily.git"
MEETILY_SOURCE_DIR="$HOME/.local/src/meetily"

meetily_is_installed() {
  if command -v meetily >/dev/null 2>&1 ||
    test -d "/Applications/meetily.app" ||
    test -d "/Applications/Meetily.app"; then
    return 0
  fi

  for meetily_appimage in \
    "$HOME"/Applications/Meetily*.AppImage \
    "$HOME"/Applications/meetily*.AppImage \
    "$HOME"/.local/bin/Meetily*.AppImage \
    "$HOME"/.local/bin/meetily*.AppImage; do
    if test -x "$meetily_appimage"; then
      return 0
    fi
  done

  return 1
}

clone_meetily() {
  if test -d "$MEETILY_SOURCE_DIR/.git"; then
    echo "Using existing Meetily source at $MEETILY_SOURCE_DIR."
    return
  fi

  if test -e "$MEETILY_SOURCE_DIR"; then
    echo "$MEETILY_SOURCE_DIR exists but is not a Git checkout; cannot install Meetily." >&2
    exit 1
  fi

  mkdir -p "$(dirname "$MEETILY_SOURCE_DIR")"
  git clone --branch "v$MEETILY_VERSION" --depth 1 "$MEETILY_REPOSITORY" "$MEETILY_SOURCE_DIR"
}

install_rustup() {
  if command -v cargo >/dev/null 2>&1; then
    return
  fi

  echo "Installing the Rust toolchain required to build Meetily..."
  curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal
  # shellcheck disable=SC1091
  . "$HOME/.cargo/env"
}

install_pnpm() {
  if command -v pnpm >/dev/null 2>&1; then
    return
  fi

  echo "Installing pnpm for the Meetily frontend build..."
  mkdir -p "$HOME/.local/bin"
  npm install --global --prefix "$HOME/.local" pnpm
  PATH="$HOME/.local/bin:$PATH"
  export PATH
}

build_meetily() {
  clone_meetily
  install_rustup
  install_pnpm

  echo "Installing Meetily frontend dependencies..."
  (
    cd "$MEETILY_SOURCE_DIR/frontend"
    pnpm install --no-frozen-lockfile
    ./build-gpu.sh
  )
}

install_meetily_linux() {
  MEETILY_LINUX_BUILD_GUIDE="https://github.com/Zackriya-Solutions/meetily/blob/main/docs/building_in_linux.md"

  echo "Meetily does not publish a Linux installer. Opening the official build instructions..."
  if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$MEETILY_LINUX_BUILD_GUIDE" >/dev/null 2>&1 ||
      echo "Open $MEETILY_LINUX_BUILD_GUIDE"
  else
    echo "Open $MEETILY_LINUX_BUILD_GUIDE"
  fi
}

install_meetily_macos_arm64() {
  MEETILY_TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/meetily.XXXXXX")
  MEETILY_DMG="$MEETILY_TEMP_DIR/meetily.dmg"
  MEETILY_MOUNT="$MEETILY_TEMP_DIR/mount"
  mkdir -p "$MEETILY_MOUNT"

  cleanup_meetily_dmg() {
    hdiutil detach "$MEETILY_MOUNT" >/dev/null 2>&1 || true
    rm -rf "$MEETILY_TEMP_DIR"
  }
  trap cleanup_meetily_dmg EXIT HUP INT TERM

  echo "Downloading Meetily v$MEETILY_VERSION for Apple Silicon..."
  curl -fL \
    "https://github.com/Zackriya-Solutions/meetily/releases/download/v$MEETILY_VERSION/meetily_${MEETILY_VERSION}_aarch64.dmg" \
    -o "$MEETILY_DMG"
  hdiutil attach -nobrowse -readonly -mountpoint "$MEETILY_MOUNT" "$MEETILY_DMG" >/dev/null

  MEETILY_APP=$(find "$MEETILY_MOUNT" -maxdepth 2 -type d -name '*.app' -print | head -n 1)
  if test -z "$MEETILY_APP"; then
    echo "The Meetily disk image did not contain an application bundle." >&2
    exit 1
  fi

  echo "Installing Meetily in /Applications..."
  sudo ditto "$MEETILY_APP" "/Applications/$(basename "$MEETILY_APP")"
}

install_meetily_macos_intel() {
  echo "Meetily does not publish an Intel macOS binary; building it from source..."
  brew install cmake node pnpm rust
  build_meetily

  MEETILY_APP=$(find "$MEETILY_SOURCE_DIR/target/release/bundle/macos" -maxdepth 1 -type d -name '*.app' -print 2>/dev/null | head -n 1)
  if test -z "$MEETILY_APP"; then
    echo "Meetily built, but no macOS application bundle was produced." >&2
    exit 1
  fi

  sudo ditto "$MEETILY_APP" "/Applications/$(basename "$MEETILY_APP")"
}

if meetily_is_installed; then
  echo "Meetily is already installed."
  exit 0
fi

case "$(uname -s)" in
  Linux)
    install_meetily_linux
    ;;
  Darwin)
    if test "$(uname -m)" = "arm64"; then
      install_meetily_macos_arm64
    else
      install_meetily_macos_intel
    fi
    ;;
  *)
    echo "Meetily installation is not configured for $(uname -s)."
    ;;
esac
