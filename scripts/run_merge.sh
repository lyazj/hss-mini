#!/bin/bash

if [ $# != 1 ]; then
    >&2 echo "usage: $(basename "$0") <line>"
    exit 1
fi

set -e
export LINE="$1"

cd /afs/cern.ch/user/l/legao/CMSSW_10_6_31/src/PhysicsTools/MiniAnalysis/scripts
cmsenv
eval "$(head -n "${LINE}" merge.sh | tail -n 1)"
