#!/bin/bash

DIRIN=/eos/user/l/legao/hss/samples/MiniAOD/WplusH_HToSS_WToLNu_M-125_TuneCP5_13TeV-powheg-pythia8/HIG-RunIISummer20UL18MiniAODv2-00000
DIROUT=output
mkdir -p "${DIROUT}"

for FILE in $(ls "${DIRIN}"/*.root); do
    FILEIN="file:${FILE}"
    FILEOUT="file:${DIROUT}/$(basename "${FILE/MiniAODv2/MiniAnalysis}")"
    [ -e "${FILEOUT:5}" ] && continue
    ./run.sh "${FILEIN}" "${FILEOUT}" -1 &
done
wait
