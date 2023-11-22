#!/bin/bash

CONTENT='Universe = vanilla
Executable = __TO_BE_REPLACED_EXECUTABLE

+ProjectName="cms.org.cern"

NEVENT = -1
Arguments = $(FILEIN) $(FILEOUT) $(NEVENT)

requirements = (OpSysAndVer =?= "CentOS7")
request_cpus = 1
request_memory = 1024

+JobFlavour = "espresso"

Log    = __TO_BE_REPLACED_LOGDIR/system.log
Output = __TO_BE_REPLACED_LOGDIR/program_1.log
Error  = __TO_BE_REPLACED_LOGDIR/program_2.log

should_transfer_files = YES
transfer_input_files = ""
transfer_output_files = ""
Queue FILEIN, FILEOUT from ('

DIRIN=/eos/user/l/legao/hss/samples/MiniAOD/WplusH_HToSS_WToLNu_M-125_TuneCP5_13TeV-powheg-pythia8/HIG-RunIISummer20UL18MiniAODv2-00000
DIROUT=output
LOGDIR=log
mkdir -p "${DIROUT}" "${LOGDIR}"
CONTENT="${CONTENT/__TO_BE_REPLACED_EXECUTABLE/$(readlink -f run_split.sh)}"
CONTENT="${CONTENT/__TO_BE_REPLACED_LOGDIR/${LOGDIR}}"
CONTENT="${CONTENT/__TO_BE_REPLACED_LOGDIR/${LOGDIR}}"
CONTENT="${CONTENT/__TO_BE_REPLACED_LOGDIR/${LOGDIR}}"
echo "${CONTENT}" > run.jdl

for FILE in $(ls "${DIRIN}"/*.root); do
    FILEIN="${FILE}"
    FILEOUT="${DIROUT}/$(basename "${FILE/MiniAODv2/FilteredMiniAODv2}")"
    echo "${FILEIN}, ${FILEOUT}"
done | tee -a run_split.jdl
echo ')' >> run_split.jdl
