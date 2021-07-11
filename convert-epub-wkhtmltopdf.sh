#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 1 ]; then
  >&2 echo "usage: $0 <input.epub>"
  exit 1
fi

if ! command -v ebook-convert &> /dev/null; then
  >&2 echo "This script requires Calibre command line tools."
  >&2 echo "→ https://calibre-ebook.com/"
  exit 1
fi

# TODO(jez) margin, pagesize
# TODO(jez) sansfont?
# TODO(jez) linkcolor
# TODO(jez) orphans, widows, page-break-after: avoid
# TODO(jez) it doesn't find images?
pandoc "$1" \
  --extract-media=. \
  --to=html5 \
  -V linestretch=1.2 \
  -V mainfont='Garamond Premier Pro' \
  -V fontsize=16.5pt \
  -V fontcolor=black \
  -V backgroundcolor=transparent \
  -V margin-left=144pt \
  -V margin-top=48pt \
  -V margin-right=48pt \
  -V margin-bottom=48pt \
  --pdf-engine=wkhtmltopdf \
  --pdf-engine-opt='--page-width' \
  --pdf-engine-opt='7.75in' \
  --pdf-engine-opt='--page-height' \
  --pdf-engine-opt='10.25in' \
  -o "${1%.epub}.pdf"
  # -o "${1%.epub}.html" --standalone
