#!/bin/bash

if [ $# -lt 1 ]; then
    >&2 echo "usage: $(basename "$0") <filein> [ <fileout> [ <nevent> [ <patterns> ] ] ]"
    exit 1
fi

set -e
[ ! -z "$1" ] && export FILEIN="$1" || unset FILEIN
[ ! -z "$2" ] && export FILEOUT="$2" || unset FILEOUT
[ ! -z "$3" ] && export NEVENT="$3" || unset NEVENT
[ ! -z "$4" ] && export PATTERNS="$4" || unset PATTERNS

cd /afs/cern.ch/user/l/legao/CMSSW_10_6_31/src/PhysicsTools/MiniAnalysis/scripts
cmsenv
cp x509up /tmp/x509up_u$UID
exec cmsRun MiniFilter.py
