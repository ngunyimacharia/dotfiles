#!/bin/bash

# GNOME Extensions Setup (Automated install for extensions.gnome.org ZIPs)
# Usage: ./gnome-install-extensions.sh

set -e

echo "Setting up GNOME extensions..."

if ! command -v gnome-extensions >/dev/null 2>&1; then
  echo "gnome-extensions not found. Install it first (gnome-shell)."
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required for JSON parsing. Please install it first."
  exit 1
fi

shell_version_raw=$(gnome-shell --version 2>/dev/null | awk '{print $3}')
shell_version=${shell_version_raw:-""}
shell_major_minor=$(echo "$shell_version" | cut -d. -f1-2)

if [ -z "$shell_version" ]; then
  echo "Could not detect GNOME Shell version. Install may fail."
else
  echo "Detected GNOME Shell version: $shell_version"
fi

echo ""
echo "Disabling Ubuntu default extensions..."
gnome-extensions disable tiling-assistant@ubuntu.com 2>/dev/null || true
gnome-extensions disable ubuntu-appindicators@ubuntu.com 2>/dev/null || true
gnome-extensions disable ubuntu-dock@ubuntu.com 2>/dev/null || true
gnome-extensions disable ding@rastersoft.com 2>/dev/null || true

echo ""
echo "Installing recommended GNOME extensions..."

tmp_dir=$(mktemp -d)
cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

fetch_version_tag() {
  local uuid=$1
  local info
  info=$(curl -fsSL -H "User-Agent: gnome-extension-installer/1.0" -H "Accept: application/json" "https://extensions.gnome.org/extension-info/?uuid=$uuid" || true)
  if [ -z "$info" ]; then
    echo ""
    return
  fi

  echo "$info" | python3 -c '
import json
import sys

raw = sys.stdin.read().strip()
if not raw or not raw.startswith("{"):
    print("")
    sys.exit(0)

data = json.loads(raw)
target = sys.argv[1] if len(sys.argv) > 1 else ""
version_map = data.get("shell_version_map", {})

def pick_tag(keys):
    for key in keys:
        entry = version_map.get(key)
        if entry:
            if "version_tag" in entry:
                return str(entry["version_tag"])
            if "pk" in entry:
                return str(entry["pk"])
    return ""

keys = []
if target:
    keys.append(target)
    keys.append(target.split(".")[0])

tag = pick_tag(keys)
if not tag:
    tag = str(data.get("version_tag", ""))

print(tag)
' "$shell_major_minor"
}

fetch_available_versions() {
  local uuid=$1
  local info
  info=$(curl -fsSL -H "User-Agent: gnome-extension-installer/1.0" -H "Accept: application/json" "https://extensions.gnome.org/extension-info/?uuid=$uuid" || true)
  if [ -z "$info" ]; then
    echo ""
    return
  fi

  echo "$info" | python3 -c '
import json
import sys

raw = sys.stdin.read().strip()
if not raw or not raw.startswith("{"):
    print("")
    sys.exit(0)

data = json.loads(raw)
versions = list(data.get("shell_version_map", {}).keys())

def key(v):
    parts = v.split(".")
    major = int(parts[0]) if parts and parts[0].isdigit() else 0
    minor = int(parts[1]) if len(parts) > 1 and parts[1].isdigit() else 0
    return (major, minor)

versions = sorted(versions, key=key)
print(", ".join(versions))
'
}

install_extension() {
  local name=$1
  local uuid=$2
  local url=$3

  if gnome-extensions list | grep -q "$uuid"; then
    echo "  ✓ $name already installed"
    gnome-extensions enable "$uuid" 2>/dev/null || echo "    (already enabled or needs restart)"
    return
  fi

  echo "  ↓ Installing $name"
  version_tag=$(fetch_version_tag "$uuid")
  if [ -z "$version_tag" ]; then
    echo "    Could not resolve version for $uuid"
    available_versions=$(fetch_available_versions "$uuid")
    if [ -n "$available_versions" ]; then
      echo "    Available GNOME Shell versions: $available_versions"
    fi
    echo "    Install manually: $url"
    return
  fi

  archive="$tmp_dir/${uuid}.zip"
  download_url="https://extensions.gnome.org/download-extension/${uuid}.shell-extension.zip?version_tag=${version_tag}"

  if ! curl -fL "$download_url" -o "$archive"; then
    echo "    Download failed: $download_url"
    echo "    Install manually: $url"
    return
  fi

  if gnome-extensions install "$archive" 2>/dev/null; then
    gnome-extensions enable "$uuid" 2>/dev/null || echo "    (installed; enable after restart)"
  else
    echo "    Install failed. You may need to log out/in first and retry."
  fi
}

install_extension "TopHat" "tophat@fflewddur.github.io" "https://extensions.gnome.org/extension/5219/tophat/"
install_extension "Pano" "pano@elhan.io" "https://extensions.gnome.org/extension/4526/pano/"
install_extension "Vitals" "Vitals@CoreCoding.com" "https://extensions.gnome.org/extension/4234/vitals/"
install_extension "Blur My Shell" "blur-my-shell@aunetx" "https://extensions.gnome.org/extension/3193/blur-my-shell/"

echo ""
echo "If extensions were newly installed, log out and back in (or restart GNOME)."
echo ""

echo "Currently enabled extensions:"
gnome-extensions list --enabled || echo "No extensions currently enabled"
