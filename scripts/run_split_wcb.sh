#!/bin/bash

if [ $# != 3 ] && [ $# != 4 ]; then
    >&2 echo "usage: $(basename "$0") <filein> <fileout> <nevent> [ <reverse> ]"
    exit 1
fi

set -e
touch "$2".lock
/afs/cern.ch/user/l/legao/CMSSW_10_6_31/src/PhysicsTools/MiniAnalysis/scripts/run_filter.sh "$1" "$2" "$3" "*24(*4,*5)" "$4"
rm "$2".lock
