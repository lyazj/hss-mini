#!/bin/bash

if [ $# != 3 ]; then
    >&2 echo "usage: $(basename "$0") <filein> <fileout> <nevent>"
    exit 1
fi

# Current configuration: Z -> qq, 4 flavours
for PID in 1 2 3 4; do
    "$(dirname "$0")"/run_filter.sh "$1" "$2" "${3/__FLAVOUR__/${PID}}" "23(${PID},-${PID})"
done
