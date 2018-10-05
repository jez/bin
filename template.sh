#!/usr/bin/env bash

set -euo pipefail

BINPATH="$(perl -MCwd -le 'print Cwd::abs_path(shift)' "${BASH_SOURCE[0]}")"
# cd into folder where the script is located, or quit (defensive)
# Works even if the executable is a symlink, and on macOS and Linux.
#cd "$(dirname "$BINPATH")" || exit 1

# ----- logging & colors -------------------------------------------------- {{{

red=$'\x1b[0;31m'
green=$'\x1b[0;32m'
yellow=$'\x1b[0;33m'
cyan=$'\x1b[0;36m'
cnone=$'\x1b[0m'

if [ -t 1 ]; then
  USE_COLOR=1
else
  USE_COLOR=0
fi

# Detects whether we can add colors or not
in_color() {
  local color="$1"
  shift

  if [ "$USE_COLOR" = "1" ]; then
    echo "$color$*$cnone"
  else
    echo "$*"
  fi
}

success() { echo "$(in_color "$green" "[ OK ]") $*"; }
error() {   echo "$(in_color "$red"   "[ERR!]") $*"; }
info() {    echo "$(in_color "$cyan"  "[INFO]") $*"; }
# Color entire warning to get users' attention (because we won't stop).
warn() { in_color "$yellow" "[WARN] $*"; }

# }}}

# ----- helper functions ------------------------------------------------------

print_help() {
  cat <<EOF

foo: TODO(jez) Name and description

Usage:
  foo [options] TODO(jez)

Options:
  TODO(jez)

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

main() {
  echo 'Hello, world!'
}

main "$@"

# vim:fdm=marker
