#!/usr/bin/env bash

set -euo pipefail

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

# ----- helper functions ------------------------------------------------------

usage() {
  cat <<EOF

mergebot-submit.sh: Submit a PR with a MERGEBOT_SUBMIT comment

Usage:
  mergebot-submit.sh [<pr-number>]

This script requires hub. See http://go/using-hub

EOF
}

# ----- option parsing --------------------------------------------------------

if ! command -v hub > /dev/null; then
  fatal "This script requires hub. See http://go/using-hub"
fi

if ! command -v jq > /dev/null; then
  fatal "This script requires jq"
fi

info "Checking hub credentials"
# Make stdin /dev/null so that any interactive prompt for password fails immediately
if ! hub api < /dev/null &> /dev/null; then
  error "hub does not have an auth token."
  error "Run $(in_color "$cyan" "hub api") to create one."
  error "For help, see http://go/using-hub"
  exit 1
fi

pr_number=
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      error "Invalid option: '$1'"
      usage
      exit 0
      ;;
    *[!0-9]*)
      error "'$1' is not a valid PR number"
      usage
      exit 1
      ;;
    *)
      pr_number="$1"
      shift
      ;;
  esac
done

if [ "$pr_number" = "" ]; then
  info "Inferring PR number from current branch"
  pr_number="$(hub pr show --format="%I")"
fi

# ----- main ------------------------------------------------------------------

api_res="$(mktemp)"
# shellcheck disable=2064
trap "rm -f '$api_res'" EXIT

info "Submitting $pr_number via MERGEBOT_SUBMIT"
if ! hub api "repos/{owner}/{repo}/issues/$pr_number/comments" -F body=MERGEBOT_SUBMIT > "$api_res"; then
  cat "$api_res"
  fatal "Using 'hub api' to submit $pr_number failed."
fi

html_url=$(jq '.html_url' "$api_res")
if [ "$html_url" = "" ]; then
  fatal "Using 'hub api' to submit $pr_number failed to add a comment."
fi

success "Submitted $pr_number to MergeBot."

# vim:fdm=marker
