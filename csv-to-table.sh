#!/usr/bin/env bash

csv_to_md() {
  sed -e 's/,/ | /g' -e 's/^/| /' -e 's/$/ |/'
}

format_seconds() {
  sed -e 's/ \(\.[0-9]\{1,\}\)/ 0\1/g' | sed -e 's/\([0-9]\) /\1s /g'
}

# -- header row --
read -r line
<<< "$line" csv_to_md
# shellcheck disable=SC2001
<<< "$line" sed -e 's/[^,]\{1,\}/---/g' | csv_to_md

# -- baseline row --
read -r line
<<< "$line" csv_to_md | format_seconds

# -- rest --
uncollate | csv_to_md | format_seconds
