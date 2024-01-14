#!/bin/bash

DIROUT=root://eosuser.cern.ch//eos/user/l/legao/hss/samples/MiniAOD/WZTo1L1Nu2Q_4f_TuneCP5_13TeV-amcatnloFXFX-pythia8/EXO-RunIISummer20UL18MiniAODv2-01346-__FLAVOUR__

for FILE in $(dasgoclient -query='file dataset=/WZTo1L1Nu2Q_4f_TuneCP5_13TeV-amcatnloFXFX-pythia8/RunIISummer20UL18MiniAODv2-106X_upgrade2018_realistic_v16_L1v1-v2/MINIAODSIM'); do
    FILEIN="${FILE}"
    FILEOUT_TEMPLATE="${DIROUT}/$(basename "${FILE/MiniAODv2/MiniAnalysis}")"
    for PID in "$@"; do
        FILEOUT="${FILEOUT_TEMPLATE/__FLAVOUR__/${PID}}"
        SIZE="$(xrdfs eosuser.cern.ch stat "${FILEOUT:23}" 2>/dev/null | grep Size | grep -o '[0-9]\+')"
        [ "${SIZE}" -ge 1048576 ] 2>/dev/null && continue
        [ -z "${SIZE}" ] && xrdfs eosuser.cern.ch ls "$(dirname "${FILEOUT:23}")" | grep -q "$(basename "${FILEOUT:23}")" && continue
        echo ./run_filter.sh "${FILEIN}" "${FILEOUT}" -1 "\"23(${PID},-${PID})\""  # dry run
    done
done
