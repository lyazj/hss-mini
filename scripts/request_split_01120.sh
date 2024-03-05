#!/bin/bash

CONTENT='Universe = vanilla
Executable = __TO_BE_REPLACED_EXECUTABLE

+ProjectName="cms.org.cern"

NEVENT = -1
Arguments = $(FILEIN) $(FILEOUT) $(NEVENT)

request_cpus = 1
request_memory = 1024

on_exit_remove        = (ExitBySignal == False) && (ExitCode == 0)
on_exit_hold          = (ExitBySignal == True) || (ExitCode != 0)
on_exit_hold_reason   = strcat("Job held by ON_EXIT_HOLD due to ", ifThenElse((ExitBySignal == True), strcat("exit signal ", ExitSignal), strcat("exit code ", ExitCode)), ".")
periodic_release      = (NumJobStarts < 3) && ((CurrentTime - EnteredCurrentStatus) > 60*60)

+JobFlavour = "tomorrow"

Log    = __TO_BE_REPLACED_LOGDIR/system.log
Output = __TO_BE_REPLACED_LOGDIR/program_1.log
Error  = __TO_BE_REPLACED_LOGDIR/program_2.log

should_transfer_files = YES
transfer_input_files = ""
transfer_output_files = ""
Queue FILEIN, FILEOUT from ('

DIROUT=root://eosuser.cern.ch//eos/user/l/legao/hss/samples/MiniAOD2/WJetsToQQ_HT-200to400_TuneCP5_13TeV-madgraphMLM-pythia8/HIG-RunIISummer20UL18MiniAODv2-01120-wcb
LOGDIR=log
mkdir -p "${LOGDIR}"
CONTENT="${CONTENT/__TO_BE_REPLACED_EXECUTABLE/$(readlink -f run_split_wcb.sh)}"
CONTENT="${CONTENT/__TO_BE_REPLACED_LOGDIR/${LOGDIR}}"
CONTENT="${CONTENT/__TO_BE_REPLACED_LOGDIR/${LOGDIR}}"
CONTENT="${CONTENT/__TO_BE_REPLACED_LOGDIR/${LOGDIR}}"
echo "${CONTENT}" > run_split_01120.jdl

for FILE in $(cat HIG-RunIISummer20UL18MiniAODv2-01120.txt); do
    FILEIN="${FILE}"
    FILEOUT="${DIROUT}/$(basename "${FILE/MiniAODv2/FilteredMiniAODv2}")"
    echo "${FILEIN}, ${FILEOUT}"
done | tee -a run_split_01120.jdl
echo ')' >> run_split_01120.jdl
