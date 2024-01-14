#!/bin/bash

if [ $# -lt 1 ]; then
    >&2 echo "usage: $(basename "$0") <filein> [ <fileout> [ <nevent> [ <patterns> ] ] ]"
    exit 1
fi

[ ! -z "$1" ] && export FILEIN="$1" || unset FILEIN
[ ! -z "$2" ] && export FILEOUT="$2" || unset FILEOUT
[ ! -z "$3" ] && export NEVENT="$3" || unset NEVENT
[ ! -z "$4" ] && export PATTERNS="$4" || unset PATTERNS

SIZE="$(xrdfs eosuser.cern.ch stat "${FILEOUT:23}" 2>/dev/null | grep Size | grep -o '[0-9]\+')"
[ "${SIZE}" -ge 1048576 ] 2>/dev/null && exit 0
[ -z "${SIZE}" ] && xrdfs eosuser.cern.ch ls "$(dirname "${FILEOUT:23}")" | grep -q "$(basename "${FILEOUT:23}")" && exit 0

set -e
cd /afs/cern.ch/user/l/legao/CMSSW_10_6_31/src/PhysicsTools/MiniAnalysis/scripts
cmsenv
cp x509up /tmp/x509up_u$UID || :
exec cmsRun --numThreads 8 MiniFilter.py
