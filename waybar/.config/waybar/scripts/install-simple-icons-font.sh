#!/bin/bash
# Installs the "Simple Icons" brand-icon font (TTF) for Waybar VPN icons.
# Pinned to a fixed version on purpose: the font's glyph codepoints shift
# between releases, and vpn.sh references the codepoints of this version.
set -euo pipefail

VERSION="16.4.0"
DEST="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
URL="https://cdn.jsdelivr.net/npm/simple-icons-font@${VERSION}/font/SimpleIcons.ttf"
FONT_FILE="$DEST/SimpleIcons.ttf"

if fc-list 2>/dev/null | grep -i 'Simple Icons' >/dev/null; then
    echo "Simple Icons font already installed."
    exit 0
fi

mkdir -p "$DEST"
echo "Downloading Simple Icons font v${VERSION} ..."
curl -fL --retry 3 -o "$FONT_FILE" "$URL"
fc-cache -f >/dev/null 2>&1

if fc-list 2>/dev/null | grep -i 'Simple Icons' >/dev/null; then
    echo "OK: Simple Icons font installed."
else
    echo "ERROR: font was downloaded but not detected by fontconfig." >&2
    exit 1
fi