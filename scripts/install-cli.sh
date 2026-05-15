#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="$ROOT_DIR/plugins/autodl-remote/bin/autodl-remote"
DEST_DIR="${1:-/opt/homebrew/bin}"
DEST="$DEST_DIR/autodl-remote"

if [ ! -f "$SOURCE" ]; then
  echo "Missing CLI source: $SOURCE" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"
ln -sf "$SOURCE" "$DEST"
chmod +x "$SOURCE"

echo "Installed autodl-remote -> $DEST"
echo "Run: autodl-remote --help"
