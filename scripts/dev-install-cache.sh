#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_DIR="$ROOT_DIR/plugins/autodl-remote"
PLUGIN_JSON="$PLUGIN_DIR/.codex-plugin/plugin.json"
CACHE_ROOT="${CODEX_AUTODL_REMOTE_CACHE_ROOT:-$HOME/.codex/plugins/cache/local-codex-plugins/autodl-remote}"
KEEP_OLD=false

while [ $# -gt 0 ]; do
  case "$1" in
    --keep-old)
      KEEP_OLD=true
      shift
      ;;
    --cache-root)
      [ $# -ge 2 ] || { echo "--cache-root requires a path" >&2; exit 2; }
      CACHE_ROOT="$2"
      shift 2
      ;;
    -h|--help)
      cat <<'EOF'
Usage: scripts/dev-install-cache.sh [--keep-old] [--cache-root path]

Copy the current plugin source into the Codex App local plugin cache.

Environment:
  CODEX_AUTODL_REMOTE_CACHE_ROOT  Override the cache root.
EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 2
      ;;
  esac
done

if [ ! -f "$PLUGIN_JSON" ]; then
  echo "Missing plugin.json: $PLUGIN_JSON" >&2
  exit 1
fi

VERSION="$(
  sed -n 's/^[[:space:]]*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$PLUGIN_JSON" | head -n 1
)"

if [ -z "$VERSION" ]; then
  echo "Could not read plugin version from $PLUGIN_JSON" >&2
  exit 1
fi

DEST="$CACHE_ROOT/$VERSION"
mkdir -p "$CACHE_ROOT"
rm -rf "$DEST"
mkdir -p "$DEST"

if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete --exclude '.DS_Store' "$PLUGIN_DIR"/ "$DEST"/
else
  (cd "$PLUGIN_DIR" && tar cf - .) | (cd "$DEST" && tar xf -)
fi

chmod +x "$DEST/bin/autodl-remote"

if [ "$KEEP_OLD" = false ]; then
  for old in "$CACHE_ROOT"/*; do
    [ -d "$old" ] || continue
    [ "$old" = "$DEST" ] && continue
    rm -rf "$old"
  done
fi

"$ROOT_DIR/scripts/install-cli.sh" >/dev/null

echo "Installed plugin cache: $DEST"
echo "Installed CLI symlink via scripts/install-cli.sh"
