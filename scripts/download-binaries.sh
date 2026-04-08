#!/bin/bash
set -euo pipefail

VERSION="${1:-latest}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$SCRIPT_DIR/../bin"
TEMP_DIR="$(mktemp -d)"

# Targets to download
TARGETS=(
  "aarch64-apple-darwin"
  "x86_64-apple-darwin"
  "aarch64-unknown-linux-musl"
  "x86_64-unknown-linux-musl"
)

# Resolve version
if [ "$VERSION" = "latest" ]; then
  echo "Fetching latest Typst version..."
  VERSION="$(curl -sI https://github.com/typst/typst/releases/latest | grep -i '^location:' | sed 's/.*tag\///' | tr -d '\r\n')"
fi

echo "Downloading Typst $VERSION binaries..."

cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

for TARGET in "${TARGETS[@]}"; do
  ARCHIVE="typst-${TARGET}.tar.xz"
  URL="https://github.com/typst/typst/releases/download/${VERSION}/${ARCHIVE}"
  DEST="$BIN_DIR/typst-${TARGET}"

  echo "  Downloading $ARCHIVE..."
  curl -sL "$URL" -o "$TEMP_DIR/$ARCHIVE"

  echo "  Extracting..."
  tar -xf "$TEMP_DIR/$ARCHIVE" -C "$TEMP_DIR"

  # The archive contains typst-<target>/typst
  cp "$TEMP_DIR/typst-${TARGET}/typst" "$DEST"
  chmod +x "$DEST"

  echo "  Installed: $DEST"
done

echo ""
echo "Done! Typst $VERSION binaries installed to $BIN_DIR"
echo "Verify with: bin/typst --version"
