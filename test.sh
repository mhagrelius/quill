#!/usr/bin/env bash
#
# Run the whole suite the way CI would, in the order that fails fastest.
#
#   ./test.sh
#
# No --headless here, unlike the apps that use this: nothing in this crate
# draws, so nothing in it needs a display.
set -euo pipefail
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export RUST_BACKTRACE=1

echo "==> cargo fmt --check"
cargo fmt --check

echo "==> cargo clippy"
cargo clippy --all-targets -- -D warnings

echo "==> cargo test"
cargo test --all-targets

echo
echo "All checks passed."
