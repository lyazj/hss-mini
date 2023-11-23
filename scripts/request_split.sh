#!/bin/bash

CONTENT='Universe = vanilla
Executable = __TO_BE_REPLACED_EXECUTABLE

+ProjectName="cms.org.cern"

NEVENT = -1
Arguments = $(FILEIN) $(FILEOUT) $(NEVENT)

requirements = (OpSysAndVer =?= "CentOS7")
request_cpus = 8
request_memory = 1024

+JobFlavour = "tomorrow"

Log    = __TO_BE_REPLACED_LOGDIR/system.log
Output = __TO_BE_REPLACED_LOGDIR/program_1.log
Error  = __TO_BE_REPLACED_LOGDIR/program_2.log

should_transfer_files = YES
transfer_input_files = ""
transfer_output_files = ""
Queue FILEIN, FILEOUT from ('

DIROUT=root://eosuser.cern.ch//eos/user/l/legao/hss/samples/MiniAOD/WZTo1L1Nu2Q_4f_TuneCP5_13TeV-amcatnloFXFX-pythia8/EXO-RunIISummer20UL18MiniAODv2-01346-__FLAVOUR__
LOGDIR=log
mkdir -p "${LOGDIR}"
CONTENT="${CONTENT/__TO_BE_REPLACED_EXECUTABLE/$(readlink -f run_split.sh)}"
CONTENT="${CONTENT/__TO_BE_REPLACED_LOGDIR/${LOGDIR}}"
CONTENT="${CONTENT/__TO_BE_REPLACED_LOGDIR/${LOGDIR}}"
CONTENT="${CONTENT/__TO_BE_REPLACED_LOGDIR/${LOGDIR}}"
echo "${CONTENT}" > run_split.jdl

for FILE in $(dasgoclient -query='file dataset=/WZTo1L1Nu2Q_4f_TuneCP5_13TeV-amcatnloFXFX-pythia8/RunIISummer20UL18MiniAODv2-106X_upgrade2018_realistic_v16_L1v1-v2/MINIAODSIM'); do
    FILEIN="${FILE}"
    FILEOUT="${DIROUT}/$(basename "${FILE/MiniAODv2/FilteredMiniAODv2}")"
    echo "${FILEIN}, ${FILEOUT}"
done | tee -a run_split.jdl
echo ')' >> run_split.jdl
