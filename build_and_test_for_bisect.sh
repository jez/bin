#!/usr/bin/env bash

set -euo pipefail
set -x

if ! bazel build "$@"; then
  exit 125
fi

exec bazel test --test_output=errors "$@"
