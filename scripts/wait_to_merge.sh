#!/bin/bash

while true; do
    if [ $(ls /eos/user/l/legao/hss/src/aod/WplusH_HToSS_WToLNu_M-125_TuneCP5_13TeV-powheg-pythia8/HIG-RunIISummer20UL18MiniAODv2-00000/output/*.root | wc -l) = 6000 ]; then
        ./request_merge.py /eos/user/l/legao/hss/src/aod/WplusH_HToSS_WToLNu_M-125_TuneCP5_13TeV-powheg-pythia8/HIG-RunIISummer20UL18MiniAODv2-00000/output/ /eos/user/l/legao/hss/samples/MiniAOD/WplusH_HToSS_WToLNu_M-125_TuneCP5_13TeV-powheg-pythia8/HIG-RunIISummer20UL18MiniAODv2-00000/
        condor_submit -file run_merge.jdl
        break
    fi
    sleep 30
done
