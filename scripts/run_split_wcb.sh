#!/bin/bash

if [ $# != 3 ]; then
    >&2 echo "usage: $(basename "$0") <filein> <fileout> <nevent>"
    exit 1
fi

/afs/cern.ch/user/l/legao/CMSSW_10_6_31/src/PhysicsTools/MiniAnalysis/scripts/run_filter.sh "$1" "$2" "$3" "*24(*4,*5)"
