#!/bin/bash

if [ $# != 3 ] && [ $# != 4 ]; then
    >&2 echo "usage: $(basename "$0") <filein> <fileout> <nevent> [ <reverse> ]"
    exit 1
fi

set -e
LOCKDIR=/afs/cern.ch/user/l/legao/CMSSW_10_6_31/src/PhysicsTools/MiniAnalysis/scripts/lock
LOCKNAME="$(sed 's@/@_@g' <<< "$2")"
LOCK="${LOCKDIR}"/"${LOCKNAME}"
mkdir -p "${LOCKDIR}"
mkdir "${LOCK}" 2>/dev/null || rm "$(sed 's@^root://[^/]*/@@g' <<< "$2")"
mkdir -p "${LOCK}"
/afs/cern.ch/user/l/legao/CMSSW_10_6_31/src/PhysicsTools/MiniAnalysis/scripts/run_filter.sh "$1" "$2" "$3" "*24(*4,*5)" "$4"
rmdir "${LOCK}"
