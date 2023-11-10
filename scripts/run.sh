#!/bin/bash

if [ $# -lt 1 ]; then
    >&2 echo "usage: $(basename "$0") <filein> [ <fileout> [ <nevent> ] ]"
    exit 1
fi

set -ev
export FILEIN="$1"
export FILEOUT="$2"
export NEVENT="$3"

cd /afs/cern.ch/user/l/legao/CMSSW_10_6_31/src/PhysicsTools/MiniAnalysis/scripts
cmsenv
exec cmsRun MiniAnalysis.py
