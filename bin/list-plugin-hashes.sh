#!/bin/bash
cd "$(dirname "$0")/../data/nvim12/site/pack/core/opt" || exit 1
for dir in */; do
    name="${dir%/}"
    hash="$(git -C "$dir" rev-parse HEAD 2>/dev/null || echo 'NOT_A_GIT_REPO')"
    printf "%-30s %s\n" "$name" "$hash"
done
