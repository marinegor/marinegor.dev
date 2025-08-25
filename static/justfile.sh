#!/usr/bin/env bash
set -euo pipefail
if ! command -v cargo &> /dev/null; then curl https://sh.rustup.rs -sSf | sh -s -- -y; fi
. "$HOME/.cargo/env"
if ! command -v just &> /dev/null; then cargo install just; fi
rm -f /tmp/marinegor.just mini.just
cat > mini.just<< EOF
import? '/tmp/marinegor.just'
fetch:
  rm -f /tmp/marinegor.just
  curl -LsSf https://marinegor.dev/justfile > /tmp/marinegor.just
all:
  just --justfile mini.just install-all
default: all
EOF
just --justfile mini.just fetch && just --justfile mini.just all && rm mini.just
