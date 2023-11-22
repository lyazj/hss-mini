#!/bin/bash

if [ $# != 3 ]; then
    >&2 echo "usage: $(basename "$0") <filein> <fileout> <nevent>"
    exit 1
fi

# Current configuration: Z -> qq, 4 flavours
for PID in 1 2 3 4; do
    /afs/cern.ch/user/l/legao/CMSSW_10_6_31/src/PhysicsTools/MiniAnalysis/scripts/run_filter.sh "$1" "${2/__FLAVOUR__/${PID}}" "$3" "23(${PID},-${PID})"
done
