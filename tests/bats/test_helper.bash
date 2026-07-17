#!/bin/bash
# Helper for loading etersoft-build-utils modules in bats tests
# Usage: load test_helper

# Resolve project root relative to this file
PROJECT_ROOT="$(cd "$(dirname "${BATS_TEST_FILENAME}")/../.." && pwd)"

# Pre-set paths so set_eterbuilddir skips $0-based detection
export ETERBUILDDIR="$PROJECT_ROOT/share/eterbuild"
export ETERBUILDETC="$PROJECT_ROOT/etc"
export ETERBUILDBIN="$PROJECT_ROOT/bin"

# Allow root in tests (UID check in common would block us)
export ALLOW_ROOT_USER=1

# Suppress terminal output
export TERMOUTPUT=
export TERM=dumb

load_common() {
    source "$PROJECT_ROOT/share/eterbuild/functions/common"
}

load_mod() {
    load_common
    local mod
    for mod in "$@"; do
        . "$PROJECT_ROOT/share/eterbuild/functions/$mod"
    done
}
