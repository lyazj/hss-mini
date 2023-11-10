#!/bin/bash

if [ $# != 1 ]; then
    >&2 echo "usage: $(basename "$0") <line>"
    exit 1
fi

set -e
export LINE="$1"

cd "$(dirname "$0")"
cmsenv
eval "$(head -n "${LINE}" merge.sh | tail -n 1)"
