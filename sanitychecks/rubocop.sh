#!/bin/sh -e
repoRoot="$(readlink -f "$(dirname "$0")")/.."
cd "$repoRoot" || exit 1

# shellcheck disable=SC2044
for rubyfile in $(find . -name "*.rb"); do
    echo "$rubyfile"
    echo
    rubocop "$rubyfile"
done
