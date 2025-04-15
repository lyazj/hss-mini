#!/bin/bash

INPUTS=""
for FILE in $(ls -v /eos/user/l/legao/MiniAODStore/V0/2018/MC/HplusToCS_M-75_TuneCP5_13TeV-madgraph-pythia8/HIG-RunIISummer20UL18wmLHEGEN-MS075/?.root /eos/user/l/legao/MiniAODStore/V0/2018/MC/HplusToCS_M-75_TuneCP5_13TeV-madgraph-pythia8/HIG-RunIISummer20UL18wmLHEGEN-MS075/??.root); do
    INPUTS=${INPUTS},file:${FILE}
done
INPUTS=${INPUTS:1}
edmCopyPickMerge inputFiles=${INPUTS} outputFile=file:HIG-RunIISummer20UL18wmLHEGEN-MS075_0-99.root
