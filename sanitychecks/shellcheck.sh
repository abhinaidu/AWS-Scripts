#!/bin/sh -e
repoRoot="$(readlink -f "$(dirname "$0")")/.."
cd "$repoRoot" || exit 1

# shellcheck disable=SC2044
for shfile in $(find . -name "*.sh"); do
    echo "$shfile"
    echo
    shellcheck "$shfile"
done
