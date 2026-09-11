#!/bin/sh
# Fetch Omarchy's per-theme wallpapers into
# ~/.local/share/dotfiles-themes-backgrounds/<theme>/.
#
# Omarchy (https://github.com/basecamp/omarchy) ships a themes/<name>/backgrounds/
# directory of hand-picked images for 22 of the themes in palette.toml. We want
# those wallpapers available locally, but we do not vendor them in this repo:
# the full set is ~52 MiB of binary images across 92 files, which would bloat
# a dotfiles repo forever, and Omarchy states no license or attribution terms
# for them anywhere (manual/39-backgrounds.md doesn't cover it either). So
# instead of committing the bytes, this pulls them straight from upstream at
# apply time - the images stay in Omarchy's repo, and running this script just
# downloads what you could download yourself.
#
# To avoid pulling all of Omarchy's history and every other directory, this
# uses a blobless, sparse, depth-1 clone and narrows the checkout to themes/
# before anything is copied.
#
# This is run_once_, not run_onchange_, on purpose: it's a large network
# fetch (tens of MiB), and it must not re-run just because someone edits a
# hex code in palette.toml. The destination-already-populated guard below is
# what makes it safe to re-run by hand if you ever need to force it (e.g.
# after deleting the destination).
#
# Almost every theme also ships an Omarchy logo image rather than a wallpaper:
# usually named omarchy.webp, but sometimes prefixed (lupine/06-omarchy.webp,
# flexoki-light/2-omarchy.webp). All of them are full 3840x2160 images with the
# word OMARCHY across an otherwise empty background, so they are skipped by
# suffix rather than exact name.
#
# Note: ~/.local/share/dotfiles-themes-backgrounds is NOT a chezmoi-managed
# path. It's populated by this script only, and chezmoi should never be
# taught to manage it directly - see .chezmoiscripts/run_onchange_generate-
# wallpapers.sh.tmpl and palette.toml for the (separate) generated-themes
# directory this must not collide with.

set -eu

REPO_URL="https://github.com/basecamp/omarchy"
DEST_ROOT="$HOME/.local/share/dotfiles-themes-backgrounds"

if ! command -v git >/dev/null 2>&1; then
    echo "git not found; skipping Omarchy wallpaper fetch"
    exit 0
fi

# If the destination already has images, assume a previous run populated it
# and skip. Re-running by hand after deleting the destination forces a fetch.
if [ -d "$DEST_ROOT" ] && find "$DEST_ROOT" -mindepth 2 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
    2>/dev/null | grep -q .; then
    echo "Omarchy wallpapers already present in $DEST_ROOT; skipping fetch"
    exit 0
fi

tmp=""
cleanup() {
    if [ -n "$tmp" ] && [ -d "$tmp" ]; then
        rm -rf "$tmp"
    fi
}
trap cleanup EXIT INT TERM HUP

tmp=$(mktemp -d)

if ! git clone --filter=blob:none --sparse --depth 1 "$REPO_URL" "$tmp" >/dev/null 2>&1; then
    echo "Could not clone $REPO_URL; skipping Omarchy wallpaper fetch"
    exit 0
fi

if ! git -C "$tmp" sparse-checkout set themes >/dev/null 2>&1; then
    echo "Sparse checkout of themes/ failed; skipping Omarchy wallpaper fetch"
    exit 0
fi

if [ ! -d "$tmp/themes" ]; then
    echo "themes/ missing after sparse checkout; skipping Omarchy wallpaper fetch"
    exit 0
fi

theme_count=0
image_count=0

for theme_dir in "$tmp"/themes/*/; do
    [ -d "${theme_dir}backgrounds" ] || continue
    theme=$(basename "$theme_dir")
    copied_any=0

    for f in "${theme_dir}backgrounds"/*; do
        [ -f "$f" ] || continue
        fname=$(basename "$f")

        # The Omarchy branding image, not a wallpaper. Matches omarchy.webp
        # and the prefixed variants some themes use.
        case "$fname" in
            *omarchy.webp) continue ;;
        esac

        case "$fname" in
            *.jpg | *.jpeg | *.png | *.webp) ;;
            *) continue ;;
        esac

        mkdir -p "$DEST_ROOT/$theme"
        cp "$f" "$DEST_ROOT/$theme/"
        copied_any=1
        image_count=$((image_count + 1))
    done

    if [ "$copied_any" = "1" ]; then
        theme_count=$((theme_count + 1))
    fi
done

if [ "$image_count" = "0" ]; then
    echo "No wallpapers found in Omarchy checkout; nothing fetched"
    exit 0
fi

total_size=$(du -sh "$DEST_ROOT" 2>/dev/null | cut -f1)
echo "Fetched $image_count Omarchy wallpaper(s) across $theme_count theme(s) into $DEST_ROOT ($total_size)"
