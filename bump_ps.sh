#!/usr/bin/env bash

set -euo pipefail

message_file="$(mktemp)"
# shellcheck disable=SC2064
trap "rm -rf '$message_file'" EXIT

OLD_SHA_FULL="$(cat ~/stripe/pay-server/sorbet/sorbet.sha)"
NEW_SHA_FULL="$(git rev-parse HEAD)"

OLD_SHA="$(git rev-parse --short "$OLD_SHA_FULL")"
NEW_SHA="$(git rev-parse --short "$NEW_SHA_FULL")"

generate_commit_message() {
  echo "Bump sorbet: $OLD_SHA -> $NEW_SHA"
  echo ''
  echo 'New changes in this bump:'
  echo ''
  git log --reverse --date=format-local:%Y-%m-%d --pretty="- (%h) %s%n  - %an, %cd" "$OLD_SHA_FULL..$NEW_SHA_FULL" | \
    sed -e 's+(\([0-9a-f]*\))+([\1](https://github.com/sorbet/sorbet/commit/\1))+' | \
    sed -e 's+(\(#[0-9]*\))+([\1](https://github.com/sorbet/sorbet/pull/\1))+'
}

generate_commit_message >> "$message_file"

cd ~/stripe/pay-server

echo "$NEW_SHA_FULL" > sorbet/sorbet.sha
git add sorbet/sorbet.sha
git checkout -b "$USER-sorbet-$NEW_SHA"
git commit -F "$message_file"
git push -u origin "$USER-sorbet-$NEW_SHA"

echo '' >> "$message_file"
cat .github/PULL_REQUEST_TEMPLATE.md >> "$message_file"

hub pull-request -F "$message_file" --edit
