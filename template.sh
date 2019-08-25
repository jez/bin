#!/usr/bin/env bash

set -euo pipefail

# cd into folder where the script is located, or quit (defensive)
# Works even if the executable is a symlink, and on macOS and Linux.
# Uses perl because this incantation was tested to be faster than alternatives.
# BINPATH="$(perl -MCwd -le 'print Cwd::abs_path(shift)' "${BASH_SOURCE[0]}")"
# cd "$(dirname "$BINPATH")" || exit 1

# ----- logging & colors -------------------------------------------------- {{{

red=$'\x1b[0;31m'
green=$'\x1b[0;32m'
yellow=$'\x1b[0;33m'
cyan=$'\x1b[0;36m'
cnone=$'\x1b[0m'

USE_COLOR=
if [ -t 1 ]; then
  USE_COLOR=1
fi

# Detects whether we can add colors or not
in_color() {
  local color="$1"
  shift

  if [ -z "$USE_COLOR" ]; then
    echo "$*"
  else
    echo "$color$*$cnone"
  fi
}

success() { echo "$(in_color "$green" "[ OK ]") $*"; }
error() { echo "$(in_color "$red" "[ERR!]") $*"; }
info() { echo "$(in_color "$cyan" "[ .. ]") $*"; }
fatal() { error "$@"; exit 1; }
# Color entire message to get users' attention (because we won't stop).
attn() { in_color "$yellow" "[ .. ] $*"; }

# }}}

# ----- debugging --------------------------------------------------------- {{{

stop_in_repl() {
  echo "Stopped in REPL. Press ^D to resume, or ^C to abort execution."
  local line
  while read -r -p "> " line; do
    eval "$line"
  done
  echo
}

# }}}

# ----- helper functions ------------------------------------------------------

usage() {
  cat <<EOF

foo: TODO Name and description

Usage:
  foo [options] TODO incantations

Arguments:
  TODO Required (positional) arguments

Options:
  TODO optional flags

EOF
}

# ----- option parsing --------------------------------------------------------

while [[ $# -gt 0 ]]; do
  case $1 in
    *)
      shift
      ;;
  esac
done

# ----- main ------------------------------------------------------------------

echo 'Hello, world!'

# vim:fdm=marker
