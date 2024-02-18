#!/bin/bash

for DIROUT in \
root://eosuser.cern.ch//eos/user/l/legao/hss/samples/MiniAOD/WJetsToQQ_HT-200to400_TuneCP5_13TeV-madgraphMLM-pythia8/HIG-RunIISummer20UL18MiniAODv2-01120-wcb \
root://eosuser.cern.ch//eos/user/l/legao/hss/samples/MiniAOD/WJetsToQQ_HT-400to600_TuneCP5_13TeV-madgraphMLM-pythia8/HIG-RunIISummer20UL18MiniAODv2-00715-wcb \
root://eosuser.cern.ch//eos/user/l/legao/hss/samples/MiniAOD/WJetsToQQ_HT-600to800_TuneCP5_13TeV-madgraphMLM-pythia8/HIG-RunIISummer20UL18MiniAODv2-00714-wcb \
root://eosuser.cern.ch//eos/user/l/legao/hss/samples/MiniAOD/WJetsToQQ_HT-800toInf_TuneCP5_13TeV-madgraphMLM-pythia8/HIG-RunIISummer20UL18MiniAODv2-00716-wcb \
; do

    BASEDIR=$(basename ${DIROUT})
    for FILE in $(cat ${BASEDIR/-wcb/.txt}); do
        FILEIN="${FILE}"
        FILEOUT="${DIROUT}/"$(basename "${FILEIN}")""
        SIZE="$(xrdfs eosuser.cern.ch stat "${FILEOUT:23}" 2>/dev/null | grep Size | grep -o '[0-9]\+')"
        [ "${SIZE}" -ge 1048576 ] 2>/dev/null && continue
        [ -z "${SIZE}" ] && xrdfs eosuser.cern.ch ls "$(dirname "${FILEOUT:23}")" | grep -q "$(basename "${FILEOUT:23}")" && continue
        echo ./run_filter.sh "${FILEIN}" "${FILEOUT}" -1 "\"23(${PID},-${PID})\""  # dry run
    done

done
