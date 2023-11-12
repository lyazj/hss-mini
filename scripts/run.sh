#!/bin/bash

if [ $# -lt 1 ]; then
    >&2 echo "usage: $(basename "$0") <filein> [ <fileout> [ <nevent> [ <partonFlavour> ] ] ]"
    exit 1
fi

set -e
[ ! -z "$1" ] && export FILEIN="$1" || unset FILEIN
[ ! -z "$2" ] && export FILEOUT="$2" || unset FILEOUT
[ ! -z "$3" ] && export NEVENT="$3" || unset NEVENT
[ ! -z "$4" ] && export PARTON_FLAVOUR="$4" || unset PARTON_FLAVOUR

cd /afs/cern.ch/user/l/legao/CMSSW_10_6_31/src/PhysicsTools/MiniAnalysis/scripts
cmsenv
exec cmsRun MiniAnalysis.py
