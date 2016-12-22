#!/bin/sh -e
repoRoot="$(readlink -f "$(dirname "$0")")/.."
cd "$repoRoot" || exit 1

# shellcheck disable=SC2044
for jsonfile in $(find . -name "*.json"); do
    echo "$jsonfile"
    echo
    jsonlint "$jsonfile" > /dev/null
done
