#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TAG=rust-v0.162.1
BUILD_ROOT=${CODEX_GHOST_BUILD_DIR:-${TMPDIR:-/tmp}/codex-ghost-prompt-$TAG}
SOURCE="$BUILD_ROOT/codex"
PATCH="$ROOT/patches/$TAG.patch"
BIN="$SOURCE/codex-rs/target/release/codex"

if [ ! -d "$SOURCE/.git" ]; then
  mkdir -p "$BUILD_ROOT"
  git clone --depth 1 --branch "$TAG" https://github.com/openai/codex.git "$SOURCE"
fi

actual_tag=$(git -C "$SOURCE" describe --tags --exact-match 2>/dev/null || true)
if [ "$actual_tag" != "$TAG" ]; then
  printf 'Expected upstream tag %s, got %s in %s\n' "$TAG" "${actual_tag:-unknown}" "$SOURCE" >&2
  exit 1
fi

if git -C "$SOURCE" apply --check "$PATCH" >/dev/null 2>&1; then
  git -C "$SOURCE" apply "$PATCH"
elif ! git -C "$SOURCE" diff --quiet -- \
  codex-rs/tui/src/bottom_pane/chat_composer.rs \
  codex-rs/tui/src/bottom_pane/mod.rs \
  codex-rs/tui/src/chatwidget/protocol.rs; then
  : # Patch is already applied to the expected files.
else
  printf 'Patch does not apply cleanly to upstream tag %s.\n' "$TAG" >&2
  exit 1
fi

cd "$SOURCE/codex-rs"
cargo build --release -p codex-cli --bin codex
printf 'Built Codex CLI: %s\n' "$BIN"
