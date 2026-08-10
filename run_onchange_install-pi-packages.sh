#!/bin/sh

# Install Pi extensions that should always be present.
# https://pi.dev/packages

# pi is installed by run_onchange_install-npm-packages.sh; skip if it is not
# available yet so the apply can still succeed and pick this up next time.
if ! command -v pi >/dev/null 2>&1; then
  echo "pi not found; skipping pi package install (install pi first)."
  exit 0
fi

ensure_pi_package() {
  package_name="$1"
  package_source="$2"

  if pi list 2>/dev/null | grep -q "$package_name"; then
    echo "$package_name already installed"
  else
    echo "installing $package_name..."
    pi install "$package_source"
  fi
}

# Language Server Protocol tools with configurable extension-based routing.
# https://pi.dev/packages/@narumitw/pi-lsp
ensure_pi_package "@narumitw/pi-lsp" "npm:@narumitw/pi-lsp"
