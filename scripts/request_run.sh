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

Log    = __TO_BE_REPLACED_LOGDIR/$(Cluster)_$(ID).log
Output = __TO_BE_REPLACED_LOGDIR/$(Cluster)_$(ID)_1.log
Error  = __TO_BE_REPLACED_LOGDIR/$(Cluster)_$(ID)_2.log

should_transfer_files = NO
Queue FILEIN, FILEOUT from ('

DIRIN=/eos/user/l/legao/hss/samples/MiniAOD/WplusH_HToSS_WToLNu_M-125_TuneCP5_13TeV-powheg-pythia8/HIG-RunIISummer20UL18MiniAODv2-00000
DIROUT=output
LOGDIR=log
mkdir -p "${DIROUT}" "${LOGDIR}"
CONTENT="${CONTENT/__TO_BE_REPLACED_EXECUTABLE/$(readlink -f run.sh)}"
CONTENT="${CONTENT/__TO_BE_REPLACED_LOGDIR/${LOGDIR}}"
CONTENT="${CONTENT/__TO_BE_REPLACED_LOGDIR/${LOGDIR}}"
CONTENT="${CONTENT/__TO_BE_REPLACED_LOGDIR/${LOGDIR}}"
echo "${CONTENT}" > run.jdl

for FILE in $(ls "${DIRIN}"/*.root); do
    FILEIN="${DIRIN}/${FILE}"
    FILEOUT="${DIROUT}/${FILE/MiniAODv2/MiniAnalysis}"
    echo "${FILEIN}, ${FILEOUT}"
done | tee -a run.jdl
echo ')' >> run.jdl
